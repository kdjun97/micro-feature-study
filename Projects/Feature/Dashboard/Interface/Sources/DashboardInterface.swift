import UIKit

public enum HomeAlertCase: Equatable {
    case tip
    case stopEditing
}

public enum DashboardRoute: Equatable {
    case detailRequested
    case alert(HomeAlertCase?)
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
