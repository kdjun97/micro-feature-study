import Dashboard
import DashboardInterface
import DashboardTesting
import UIKit

@main
final class DashboardDemoAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let builder = DashboardBuilder(
        useCase: MockDashboardUseCase(),
        makeHomeViewModel: { HomeViewModel() }
    )
    private var router: DashboardDemoRouter?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)

        let router = DashboardDemoRouter(navigationController: navigationController)
        let viewController = builder.makeDashboardViewController(router: router)
        navigationController.setViewControllers([viewController], animated: false)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.router = router
        self.window = window

        return true
    }
}

@MainActor
private final class DashboardDemoRouter: DashboardRouting {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func route(from route: DashboardRoute) {
        switch route {
        case .detailRequested:
            let alert = UIAlertController(
                title: "Detail",
                message: "DashboardDemo에서는 Detail 모듈을 연결하지 않습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            navigationController?.topViewController?.present(alert, animated: true)
        }
    }
}
