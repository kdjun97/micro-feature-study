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

        let router = DashboardDemoRouter(
            navigationController: navigationController,
            makeAlertView: { [builder] event in
                builder.makeDashboardAlertView(for: event)
            }
        )
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
    private let makeAlertView: @MainActor (DashboardAlertEvent) -> UIView

    init(
        navigationController: UINavigationController,
        makeAlertView: @escaping @MainActor (DashboardAlertEvent) -> UIView
    ) {
        self.navigationController = navigationController
        self.makeAlertView = makeAlertView
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
        case .alertRequested(let event):
            guard let view = navigationController?.view else { return }

            let alertView = makeAlertView(event)
            alertView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(alertView)

            NSLayoutConstraint.activate([
                alertView.topAnchor.constraint(equalTo: view.topAnchor),
                alertView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                alertView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                alertView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
}
