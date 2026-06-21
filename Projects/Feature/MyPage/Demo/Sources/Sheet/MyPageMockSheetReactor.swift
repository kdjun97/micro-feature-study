import MyPageTesting
import ReactorKit
import RxRelay
import RxSwift

final class MyPageMockSheetReactor: Reactor {
    struct State {
        let mockState: MyPageMockState
        let items: [Item]
    }

    enum Action {
        case itemTapped(Item)
    }

    enum Mutation {}

    enum Item {
        case preset(MyPageMockPreset)
        case reset
    }

    let initialState: State
    let selectedAction = PublishRelay<MyPageDemoReactor.MockAction>()

    init(state: MyPageMockState) {
        self.initialState = State(
            mockState: state,
            items: Item.all
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .itemTapped(let item):
            selectedAction.accept(item.mockAction)
            return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        state
    }
}

private extension MyPageMockSheetReactor.Item {
    static let all: [Self] = [
        .preset(.newUser),
        .preset(.heavyUser),
        .preset(.longName),
        .preset(.betaVersion),
        .preset(.minimalSupport),
        .preset(.fullSupport),
        .preset(.logoutFailure),
        .reset
    ]

    var mockAction: MyPageDemoReactor.MockAction {
        switch self {
        case .preset(let preset):
            .preset(preset)
        case .reset:
            .reset
        }
    }
}
