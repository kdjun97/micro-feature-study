import UIKit

public enum DashboardRoute: Equatable {
    case detailRequested
    case alertRequested(DashboardAlertEvent)
}

public enum DashboardAlertEvent: Equatable, Sendable {
    case tip
    case stopEditing
}

@MainActor
public protocol DashboardRouting: AnyObject {
    func route(from route: DashboardRoute)
}

public protocol DashboardBuildable {
    @MainActor
    func makeDashboardViewController(router: DashboardRouting) -> UIViewController

    @MainActor
    func makeDashboardAlertView(for event: DashboardAlertEvent) -> UIView
}

public protocol DashboardUseCaseProtocol {
    func title() -> String
}
