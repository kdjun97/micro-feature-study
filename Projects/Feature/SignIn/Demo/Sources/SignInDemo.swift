import CoreAuthTesting
import SignIn
import SignInInterface
import SignInTesting
import UIKit

@main
final class SignInDemoAppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        configuration.delegateClass = SignInDemoSceneDelegate.self
        return configuration
    }
}

@MainActor
final class SignInDemoSceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let builder = SignInBuilder(
        useCase: MockSignInUseCase.success(),
        coreAuthUseCase: MockCoreAuthUseCase.success(),
        makeSignInReactor: { SignInReactor() },
        makeSignInDetailViewModel: { SignInDetailViewModel() }
    )
    private var router: SignInDemoRouter?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        let router = SignInDemoRouter(navigationController: navigationController, builder: builder)
        let viewController = builder.makeSignInViewController(router: router)

        navigationController.setViewControllers([viewController], animated: false)
        self.router = router

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

@MainActor
private final class SignInDemoRouter: SignInRouting {
    private weak var navigationController: UINavigationController?
    private let builder: SignInBuildable

    init(navigationController: UINavigationController, builder: SignInBuildable) {
        self.navigationController = navigationController
        self.builder = builder
    }

    func route(from route: SignInRoute) {
        switch route {
        case .signInSucceeded, .dashboardRequested:
            let alert = UIAlertController(
                title: "Main",
                message: "SignInDemo에서는 Main 모듈을 연결하지 않습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            navigationController?.topViewController?.present(alert, animated: true)
        case .signInDetailRequested:
            let viewController = builder.makeSignInDetailViewController(router: self)
            navigationController?.pushViewController(viewController, animated: true)
        case .signInDetailBackRequested:
            navigationController?.popViewController(animated: true)
        }
    }
}
