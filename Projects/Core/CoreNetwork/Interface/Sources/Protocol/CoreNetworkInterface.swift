public protocol CoreNetworkProtocol: Sendable {
    func request<Response: Decodable>(_ endpoint: CoreNetworkEndpoint) async throws -> Response
}

// MARK: TokenStorage 로 교체 예정.
public protocol CoreNetworkTokenStore: Sendable {
    func accessToken() async -> String?
    func refreshToken() async -> String?
    func save(accessToken: String, refreshToken: String?) async
}
