import CoreNetworkInterface

public enum CoreNetworkTestingError: Error {
    case failed
}

public final class StubCoreNetworkClient: CoreNetworkProtocol {
    public private(set) var receivedEndpoints: [CoreNetworkEndpoint] = []
    public var result: Result<CoreNetworkResponse, Error>

    public init(response: CoreNetworkResponse = CoreNetworkResponse(isSuccess: true)) {
        self.result = .success(response)
    }

    public init(error: Error) {
        self.result = .failure(error)
    }

    public func request(_ endpoint: CoreNetworkEndpoint) async throws -> CoreNetworkResponse {
        receivedEndpoints.append(endpoint)
        return try result.get()
    }
}
