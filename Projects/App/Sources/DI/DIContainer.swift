import Main
import Root
import CoreNetwork
import CoreNetworkInterface
import DashboardInterface
import DetailInterface
import SignInInterface
import Swinject

public final class DIContainer {
    let container: Container

    public init(container: Container = Container()) {
        self.container = container
        registerKeyChainStorageDependencies()
        registerCoreNetworkDependencies()
        registerCoreAuthDependencies()
        registerSignInDependencies()
        registerDashboardDependencies()
        registerDetailDependencies()
    }
}

extension DIContainer {
    @MainActor
    public func makeRootCoordinator() -> RootCoordinator {
        guard
            let signInBuilder = container.resolve(SignInBuildable.self),
            let dashboardBuilder = container.resolve(DashboardBuildable.self),
            let detailBuilder = container.resolve(DetailBuildable.self)
        else {
            fatalError("App dependencies are not registered.")
        }

        let mainCoordinator = MainCoordinator(detailBuilder: detailBuilder)

        return RootCoordinator(
            signInBuilder: signInBuilder,
            dashboardBuilder: dashboardBuilder,
            mainCoordinator: mainCoordinator
        )
    }
}
