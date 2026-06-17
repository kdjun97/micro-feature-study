import Main
import Root
import Swinject
import UIKit

extension AppAssembly {
    func assembleApp(in container: Container) {
        container.register(AppCoordinator.self) { (resolver: Resolver, window: UIWindow) in
            let rootCoordinatorBuilder: RootCoordinatorBuildable = resolver.resolve()
            let mainCoordinatorBuilder: MainCoordinatorBuildable = resolver.resolve()
            return AppCoordinator(
                window: window,
                rootCoordinatorBuilder: rootCoordinatorBuilder,
                mainCoordinatorBuilder: mainCoordinatorBuilder
            )
        }
    }
}
