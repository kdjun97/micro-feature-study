import Base
import MyPageInterface
import UIKit

@MainActor
public protocol MyPageCoordinatorDelegate: AnyObject {
    func myPageCoordinatorDidRequestLogout(_ coordinator: MyPageCoordinator)
}

public final class MyPageCoordinator {
    public let navigationController: UINavigationController
    public weak var delegate: MyPageCoordinatorDelegate?

    private let myPageBuilder: MyPageBuildable

    public init(
        navigationController: UINavigationController = SwipeBackNavigationController(),
        myPageBuilder: MyPageBuildable,
        delegate: MyPageCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.myPageBuilder = myPageBuilder
        self.delegate = delegate
        navigationController.setNavigationBarHidden(true, animated: false)
        print("⭕ MyPageCoordinator init!")
    }

    deinit {
        print("❎ MyPageCoordinator deinit!")
    }

    @MainActor
    public func start() {
        let viewController = myPageBuilder.makeMyPageViewController(router: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension MyPageCoordinator: MyPageRouting {
    public func route(from route: MyPageRoute) {
        switch route {
        case .logoutRequested:
            delegate?.myPageCoordinatorDidRequestLogout(self)
        }
    }
}
