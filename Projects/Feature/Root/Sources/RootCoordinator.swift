import Base
import SignInInterface
import UIKit

public final class RootCoordinator {
    public let navigationController: UINavigationController
    public weak var delegate: RootCoordinatorDelegate?

    private let signInBuilder: SignInBuildable

    public init(
        navigationController: UINavigationController = SwipeBackNavigationController(),
        signInBuilder: SignInBuildable,
        delegate: RootCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        self.signInBuilder = signInBuilder
        self.delegate = delegate
    }

    @MainActor
    public func start() {
        showSignIn()
    }

    @MainActor
    private func showSignIn() {
        let viewController = signInBuilder.makeSignInViewController(router: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    @MainActor
    private func showSignInDetail() {
        let viewController = signInBuilder.makeSignInDetailViewController(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

@MainActor
public protocol RootCoordinatorDelegate: AnyObject {
    func rootCoordinatorDidFinishSignIn(_ coordinator: RootCoordinator)
}

extension RootCoordinator: SignInRouting {
    public func route(from route: SignInRoute) {
        switch route {
        case .signInSucceeded, .dashboardRequested:
            delegate?.rootCoordinatorDidFinishSignIn(self)
        case .signInDetailRequested:
            showSignInDetail()
        case .signInDetailBackRequested:
            navigationController.popViewController(animated: true)
        }
    }
}
