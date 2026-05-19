import DashboardInterface
import Main
import SignInInterface
import SwiftUI

@MainActor
public final class RootCoordinator: ObservableObject {
    @Published public var root: RootDestination = .signIn
    @Published public var signInPath: [SignInDestination] = []

    private let signInBuilder: SignInBuildable
    private let dashboardBuilder: DashboardBuildable
    let mainCoordinator: MainCoordinator

    public init(
        signInBuilder: SignInBuildable,
        dashboardBuilder: DashboardBuildable,
        mainCoordinator: MainCoordinator
    ) {
        self.signInBuilder = signInBuilder
        self.dashboardBuilder = dashboardBuilder
        self.mainCoordinator = mainCoordinator
        self.mainCoordinator.delegate = self
    }

    public func makeRootView() -> AnyView {
        switch root {
        case .signIn:
            signInBuilder.makeSignInView(router: self)
        case .main:
            AnyView(MainCoordinatorView(coordinator: mainCoordinator))
        }
    }

    public func makeSignInDestinationView(_ destination: SignInDestination) -> AnyView {
        switch destination {
        case .dashboard:
            dashboardBuilder.makeDashboardView(router: self)
        }
    }
}
