import DashboardInterface
import Dashboard
import SwiftUI

public struct DashboardTesting {
    public init() {}
}

public struct MockDashboardUseCase: DashboardUseCase {
    private let stubbedTitle: String

    public init(title: String = "Mock Dashboard") {
        self.stubbedTitle = title
    }

    public func title() -> String {
        stubbedTitle
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
