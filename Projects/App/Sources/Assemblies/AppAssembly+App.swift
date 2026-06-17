import Main
import Root
import Swinject
import UIKit

extension AppAssembly {
    func assembleApp(in container: Container) {
        container.register(AppCoordinator.self) { (resolver: Resolver, window: UIWindow) in
            AppCoordinator(
                window: window,
                makeRootCoordinator: { delegate in
                    resolver.resolve(argument: delegate)
                },
                makeMainCoordinator: { delegate in
                    resolver.resolve(argument: delegate)
                }
            )
        }
    }
}
