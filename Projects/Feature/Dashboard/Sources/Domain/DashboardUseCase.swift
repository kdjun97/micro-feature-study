import DashboardInterface

public struct DashboardUseCase: DashboardUseCaseProtocol {
    public init() {}

    public func title() -> String {
        "Dashboard"
    }
}
