import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var appDIContainer: AppDIContainer?
    private var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let diContainer = AppDIContainer()
        let coordinator = diContainer.makeAppCoordinator(window: window)

        self.window = window
        self.appDIContainer = diContainer
        self.appCoordinator = coordinator

        coordinator.start()
        window.makeKeyAndVisible()
    }
}
