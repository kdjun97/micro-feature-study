public protocol DashboardUseCase {
    func title() -> String
}

public struct DefaultDashboardUseCase: DashboardUseCase {
    public init() {}

    public func title() -> String {
        "Dashboard"
    }
}
