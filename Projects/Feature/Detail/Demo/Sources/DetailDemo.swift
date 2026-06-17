import CoreAuthTesting
import Detail
import DetailInterface
import DetailTesting
import UIKit

@main
final class DetailDemoAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let builder = DetailBuilder(
        useCase: MockDetailUseCase.success(),
        coreAuthUseCase: MockCoreAuthUseCase.success(),
        makeDetailViewModel: { DetailViewModel() }
    )
    private var router: DetailDemoRouter?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)

        let router = DetailDemoRouter(navigationController: navigationController, builder: builder)
        let viewController = builder.makeDetailViewController(router: router)
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
private final class DetailDemoRouter: DetailRouting {
    private weak var navigationController: UINavigationController?
    private let builder: DetailBuildable

    init(navigationController: UINavigationController, builder: DetailBuildable) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func route(from route: DetailRoute) {
        switch route {
        case .sheet:
            let sheetViewController = builder.makeDetailSheetViewController()
            if let sheet = sheetViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            navigationController?.topViewController?.present(sheetViewController, animated: true)
        case .logout:
            navigationController?.popToRootViewController(animated: true)
        }
    }
}
