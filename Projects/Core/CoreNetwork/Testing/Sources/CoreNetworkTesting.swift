import CoreNetworkInterface

public enum CoreNetworkTestingError: Error {
    case failed
    case responseTypeMismatch
}

public final class StubCoreNetworkClient: CoreNetworkProtocol {
    public private(set) var receivedEndpoints: [CoreNetworkEndpoint] = []
    public var result: Result<Any, Error>

    public init<Response: Decodable>(response: Response) {
        self.result = .success(response)
    }

    public init(error: Error) {
        self.result = .failure(error)
    }

    public func request<Response: Decodable>(_ endpoint: CoreNetworkEndpoint) async throws -> Response {
        receivedEndpoints.append(endpoint)

        let value = try result.get()

        guard let response = value as? Response else {
            throw CoreNetworkTestingError.responseTypeMismatch
        }

        return response
    }
}
