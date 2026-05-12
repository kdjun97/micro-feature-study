import SwiftUI

public enum DashboardRoute: Equatable {
    case backRequested
}

@MainActor
public protocol DashboardRouting: AnyObject {
    func route(from route: DashboardRoute)
}

public protocol DashboardBuildable {
    @MainActor
    func makeDashboardView(router: DashboardRouting) -> AnyView
}

public protocol DashboardUseCaseProtocol {
    func title() -> String
}
