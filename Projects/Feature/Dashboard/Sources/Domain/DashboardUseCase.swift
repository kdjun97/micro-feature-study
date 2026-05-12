import DashboardInterface

public protocol DashboardUseCaseProtocol {
    func title() -> String
}

public struct DashboardUseCase: DashboardUseCaseProtocol {
    public init() {}

    public func title() -> String {
        "Dashboard"
    }
}
