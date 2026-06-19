import MyPageTesting

final class MyPageMockStore {
    static let shared = MyPageMockStore()

    private var currentState: MyPageMockState

    init(initialState: MyPageMockState = .default) {
        self.currentState = initialState
    }

    var state: MyPageMockState {
        currentState
    }

    func apply(_ preset: MyPageMockPreset) {
        apply(preset.state)
    }

    func apply(_ state: MyPageMockState) {
        currentState = state
    }

    func reset() {
        apply(.default)
    }
}
