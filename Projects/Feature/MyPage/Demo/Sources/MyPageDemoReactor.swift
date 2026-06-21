import MyPageTesting
import ReactorKit
import RxSwift

final class MyPageDemoReactor: Reactor {
    enum MockAction {
        case preset(MyPageMockPreset)
        case reset
    }

    enum AlertCase: Equatable {
        case logoutFailed
        case logoutUnavailableInDemo
    }

    struct State: Equatable {
        var mockState: MyPageMockState
        var alertCase: AlertCase?
    }

    enum Action {
        case mockActionSelected(MockAction)
        case logoutFailed
        case logoutRequested
        case alertDismissed
    }

    enum Mutation {
        case setMockState(MyPageMockState)
        case setAlertCase(AlertCase?)
    }

    let initialState: State

    private let mockStore: MyPageMockStore

    init(mockStore: MyPageMockStore = .shared) {
        self.mockStore = mockStore
        self.initialState = State(
            mockState: mockStore.state,
            alertCase: nil
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .mockActionSelected(let action):
            apply(action)
            return .just(.setMockState(mockStore.state))
        case .logoutFailed:
            return .just(.setAlertCase(.logoutFailed))
        case .logoutRequested:
            return .just(.setAlertCase(.logoutUnavailableInDemo))
        case .alertDismissed:
            return .just(.setAlertCase(nil))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMockState(let mockState):
            newState.mockState = mockState
        case .setAlertCase(let alertCase):
            newState.alertCase = alertCase
        }
        return newState
    }

    private func apply(_ action: MockAction) {
        switch action {
        case .preset(let preset):
            mockStore.apply(preset)
        case .reset:
            mockStore.reset()
        }
    }
}
