import MyPageInterface

@MainActor
final class MyPageDemoRouter: MyPageRouting {
    private let onLogoutRequested: () -> Void

    init(onLogoutRequested: @escaping () -> Void) {
        self.onLogoutRequested = onLogoutRequested
    }

    func route(from route: MyPageRoute) {
        switch route {
        case .logoutRequested:
            onLogoutRequested()
        }
    }
}
