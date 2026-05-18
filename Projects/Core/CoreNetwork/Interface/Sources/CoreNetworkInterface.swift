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

public protocol CoreNetworkProtocol {
    func request<Response: Decodable>(_ endpoint: CoreNetworkEndpoint) async throws -> Response
}
