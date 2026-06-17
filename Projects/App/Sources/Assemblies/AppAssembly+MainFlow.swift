import DashboardInterface
import DetailInterface
import Main
import Swinject

extension AppAssembly {
    func assembleMainFlow(in container: Container) {
        container.register(MainCoordinator.self) { (resolver: Resolver, delegate: MainCoordinatorDelegate) in
            let dashboardBuilder: DashboardBuildable = resolver.resolve()
            let detailBuilder: DetailBuildable = resolver.resolve()
            return MainCoordinator(
                dashboardBuilder: dashboardBuilder,
                detailBuilder: detailBuilder,
                delegate: delegate
            )
        }
    }
}
