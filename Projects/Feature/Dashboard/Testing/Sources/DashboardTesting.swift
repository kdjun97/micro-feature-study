import DashboardInterface
import SwiftUI

public struct DashboardTesting {
    public init() {}
}

public struct MockDashboardUseCase: DashboardUseCaseProtocol {
    public init() {}
    
    public func title() -> String {
        "Mock"
    }
}

@MainActor
public final class MockDashboardRouter: DashboardRouting {
    public private(set) var routes: [DashboardRoute] = []

    public init() {}

    public func route(from route: DashboardRoute) {
        routes.append(route)
    }
}
