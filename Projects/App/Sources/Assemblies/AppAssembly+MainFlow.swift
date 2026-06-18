import DashboardInterface
import DetailInterface
import Main
import MyPageInterface
import Swinject

extension AppAssembly {
    func assembleMainFlow(in container: Container) {
        container.register(DashboardCoordinator.self) { (resolver: Resolver, delegate: DashboardCoordinatorDelegate) in
            let dashboardBuilder: DashboardBuildable = resolver.resolve()
            let detailBuilder: DetailBuildable = resolver.resolve()
            return DashboardCoordinator(
                dashboardBuilder: dashboardBuilder,
                detailBuilder: detailBuilder,
                delegate: delegate
            )
        }

        container.register(MyPageCoordinator.self) { (resolver: Resolver, delegate: MyPageCoordinatorDelegate) in
            let myPageBuilder: MyPageBuildable = resolver.resolve()
            return MyPageCoordinator(
                myPageBuilder: myPageBuilder,
                delegate: delegate
            )
        }

        container.register(MainCoordinator.self) { (resolver: Resolver, delegate: MainCoordinatorDelegate) in
            MainCoordinator(
                makeDashboardCoordinator: { delegate in resolver.resolve(argument: delegate) },
                makeMyPageCoordinator: { delegate in resolver.resolve(argument: delegate) },
                delegate: delegate
            )
        }
    }
}
