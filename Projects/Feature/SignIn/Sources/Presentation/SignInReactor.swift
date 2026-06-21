import ReactorKit
import RxRelay

public final class SignInReactor: Reactor {
    public struct State {
        
    }
    
    public enum Mutation {
        case none
    }
    
    public enum Action {
        case mainbuttonTapped
        case kakaoButtonTapped
        case appleButtonTapped
    }
    
    public enum Route: Equatable {
        case changeMain
        case pushSignInDetail
    }
    
    public let initialState: State = .init()
    let route = PublishRelay<Route>()
    
    public init() {
        print("⭕ SignInReactor init!")
    }
    
    deinit {
        print("❎ SignInReactor deinit!")
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .mainbuttonTapped:
            route.accept(.changeMain)
            return .empty()
        case .kakaoButtonTapped:
            route.accept(.pushSignInDetail)
            return .empty()
        case .appleButtonTapped:
            return .empty()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
