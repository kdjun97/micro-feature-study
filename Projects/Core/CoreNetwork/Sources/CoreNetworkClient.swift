import CoreNetworkInterface

public struct CoreNetworkClient: CoreNetworkProtocol {
    public init() {}

    public func request<Response: Decodable>(_ endpoint: CoreNetworkEndpoint) async throws -> Response {
        throw CoreNetworkClientError.notImplemented
    }
}

public enum CoreNetworkClientError: Error {
    case notImplemented
}
