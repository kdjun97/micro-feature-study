import UIKit

public final class MainCoordinator {
    public let tabBarController: MainTabBarController
    public var rootViewController: UIViewController { tabBarController }
    public weak var delegate: MainCoordinatorDelegate?

    private let makeDashboardCoordinator: (DashboardCoordinatorDelegate) -> DashboardCoordinator
    private let makeMyPageCoordinator: (MyPageCoordinatorDelegate) -> MyPageCoordinator

    private var dashboardCoordinator: DashboardCoordinator?
    private var myPageCoordinator: MyPageCoordinator?

    public init(
        tabBarController: MainTabBarController = MainTabBarController(),
        makeDashboardCoordinator: @escaping (DashboardCoordinatorDelegate) -> DashboardCoordinator,
        makeMyPageCoordinator: @escaping (MyPageCoordinatorDelegate) -> MyPageCoordinator,
        delegate: MainCoordinatorDelegate? = nil
    ) {
        self.tabBarController = tabBarController
        self.makeDashboardCoordinator = makeDashboardCoordinator
        self.makeMyPageCoordinator = makeMyPageCoordinator
        self.delegate = delegate
        print("⭕ MainCoordinator init!")
    }

    deinit {
        print("❎ MainCoordinator deinit!")
    }

    @MainActor
    public func start() {
        let dashboardCoordinator = makeDashboardCoordinator(self)
        let myPageCoordinator = makeMyPageCoordinator(self)

        self.dashboardCoordinator = dashboardCoordinator
        self.myPageCoordinator = myPageCoordinator

        dashboardCoordinator.start()
        myPageCoordinator.start()

        tabBarController.setTabs([
            MainTabRoot(tab: .dashboard, viewController: dashboardCoordinator.navigationController),
            MainTabRoot(tab: .myPage, viewController: myPageCoordinator.navigationController)
        ], animated: false)
    }
}

extension MainCoordinator: DashboardCoordinatorDelegate {
    public func dashboardCoordinatorDidRequestLogout(_ coordinator: DashboardCoordinator) {
        delegate?.mainCoordinatorDidRequestLogout(self)
    }
}

extension MainCoordinator: MyPageCoordinatorDelegate {
    public func myPageCoordinatorDidRequestLogout(_ coordinator: MyPageCoordinator) {
        delegate?.mainCoordinatorDidRequestLogout(self)
    }
}
