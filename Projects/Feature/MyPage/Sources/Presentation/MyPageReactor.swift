import MyPageInterface
import ReactorKit
import RxRelay
import RxSwift

public final class MyPageReactor: Reactor {
    public struct State {
        var supportItems: [MyPageSupportItem]
        var name: String
        var count: Int
        var appVersion: String
    }

    public enum Action {
        case logoutButtonTapped
        case viewDidLoad
        case supportItemTapped(MyPageSupportItem)
    }

    public enum Mutation {
        case updateCount(Int)
    }

    public enum Route: Equatable {
        case logout
    }

    public let initialState: State
    let route = PublishRelay<Route>()

    private let useCase: MyPageUseCaseProtocol

    public init(useCase: MyPageUseCaseProtocol) {
        self.useCase = useCase
        self.initialState = State(
            supportItems: useCase.supportItems(),
            name: useCase.userName(),
            count: useCase.emotionRecordCount(),
            appVersion: useCase.appVersion()
        )
        print("⭕ MyPageReactor init!")
    }

    deinit {
        print("❎ MyPageReactor deinit!")
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .logoutButtonTapped:
            return requestLogout()
        case .viewDidLoad:
            return .just(.updateCount(useCase.emotionRecordCount()))
        case .supportItemTapped(let item):
            switch item {
            case .logout:
                return requestLogout()
            case .privacyPolicy, .termsOfService, .versionInfo:
                return .empty()
            }
        }
    }

    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .updateCount(let value):
            newState.count = value
        }
        return newState
    }
}

private extension MyPageReactor {
    func requestLogout() -> Observable<Mutation> {
        Observable<Mutation>.create { [useCase, route] observer in
            let task = Task {
                let success = await useCase.logout()
                await MainActor.run {
                    if success {
                        route.accept(.logout)
                    }
                    observer.onCompleted()
                }
            }

            return Disposables.create {
                task.cancel()
            }
        }
    }
}
