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
        case .alert(let alertCase):
            presentAlert(for: alertCase)
        }
    }

    private func presentAlert(for alertCase: HomeAlertCase?) {
        let title: String
        let message: String

        switch alertCase {
        case .tip:
            title = "[꿀팁] 테스트 꿀팁!"
            message = "어떤게 꿀팁이 될 수 있을지 잘 모르겠지만 일단은 적어봄."
        case .stopEditing:
            title = "편집을 중단할까요?"
            message = "편집을 중단하시면 지금까지 수정한 내용이 모두 삭제됩니다."
        case .none:
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        if alertCase == .stopEditing {
            alert.addAction(UIAlertAction(title: "확인", style: .default))
        }
        navigationController?.topViewController?.present(alert, animated: true)
    }
}
