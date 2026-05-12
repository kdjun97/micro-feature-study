public struct CoreNetworkEndpoint: Equatable {
    public let path: String
    public let method: String

    public init(
        path: String,
        method: String = "GET"
    ) {
        self.path = path
        self.method = method
    }
}

public struct CoreNetworkResponse: Equatable {
    public let isSuccess: Bool

    public init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
}

public protocol CoreNetworkProtocol {
    func request(_ endpoint: CoreNetworkEndpoint) async throws -> CoreNetworkResponse
}
