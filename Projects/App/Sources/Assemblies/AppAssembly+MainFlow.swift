import DashboardInterface
import DetailInterface
import Main
import Swinject

extension AppAssembly {
    func assembleMainFlow(in container: Container) {
        container.register(MainCoordinatorBuildable.self) { resolver in
            let dashboardBuilder: DashboardBuildable = resolver.resolve()
            let detailBuilder: DetailBuildable = resolver.resolve()
            return MainCoordinatorBuilder(
                dashboardBuilder: dashboardBuilder,
                detailBuilder: detailBuilder
            )
        }
    }
}
