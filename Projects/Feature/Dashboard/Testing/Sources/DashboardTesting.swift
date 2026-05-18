import DashboardInterface
import SwiftUI

public struct DashboardTesting {
    public init() {}
}

public struct MockDashboardUseCase: DashboardUseCaseProtocol {
    private let stubTitle: String

    public init(title: String = "Mock Dashboard") {
        self.stubTitle = title
    }

    public func title() -> String {
        stubTitle
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
