import UIKit

public enum DashboardRoute: Equatable {
    case detailRequested
}

@MainActor
public protocol DashboardRouting: AnyObject {
    func route(from route: DashboardRoute)
}

public protocol DashboardBuildable {
    @MainActor
    func makeDashboardViewController(router: DashboardRouting) -> UIViewController
}

public protocol DashboardUseCaseProtocol {
    func title() -> String
}
