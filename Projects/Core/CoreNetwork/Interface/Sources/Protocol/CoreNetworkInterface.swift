public protocol CoreNetworkProtocol: Sendable {
    func request<Response: Decodable>(_ endpoint: CoreNetworkEndpoint) async throws -> Response
}
