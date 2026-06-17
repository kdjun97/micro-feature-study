import UIKit
import Root
import Main

final class AppCoordinator {
    private let window: UIWindow
    private let rootCoordinatorBuilder: RootCoordinatorBuildable
    private let mainCoordinatorBuilder: MainCoordinatorBuildable

    private var rootCoordinator: RootCoordinator?
    private var mainCoordinator: MainCoordinator?

    init(
        window: UIWindow,
        rootCoordinatorBuilder: RootCoordinatorBuildable,
        mainCoordinatorBuilder: MainCoordinatorBuildable
    ) {
        self.window = window
        self.rootCoordinatorBuilder = rootCoordinatorBuilder
        self.mainCoordinatorBuilder = mainCoordinatorBuilder
    }

    @MainActor
    func start() {
        showRoot(animated: false)
    }
}

private extension AppCoordinator {
    @MainActor
    func showRoot(animated: Bool) {
        mainCoordinator = nil

        let coordinator = rootCoordinatorBuilder.makeRootCoordinator(delegate: self)
        rootCoordinator = coordinator
        setRoot(coordinator.navigationController, animated: animated)
        coordinator.start()
    }

    @MainActor
    func showMain(animated: Bool) {
        rootCoordinator = nil

        let coordinator = mainCoordinatorBuilder.makeMainCoordinator(delegate: self)
        mainCoordinator = coordinator
        setRoot(coordinator.navigationController, animated: animated)
        coordinator.start()
    }

    @MainActor
    func setRoot(_ viewController: UIViewController, animated: Bool) {
        guard animated else {
            window.rootViewController = viewController
            return
        }

        UIView.transition(
            with: window,
            duration: 0.25,
            options: [.transitionCrossDissolve, .allowAnimatedContent],
            animations: { [weak window] in
                window?.rootViewController = viewController
            }
        )
    }
}

extension AppCoordinator: RootCoordinatorDelegate {
    @MainActor
    func rootCoordinatorDidFinishSignIn(_ coordinator: RootCoordinator) {
        showMain(animated: true)
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    @MainActor
    func mainCoordinatorDidRequestLogout(_ coordinator: MainCoordinator) {
        showRoot(animated: true)
    }
}
