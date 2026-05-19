import CoreNetworkInterface
import Foundation

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

public actor MockCoreNetworkTokenStore: CoreNetworkTokenStore {
    private var storedAccessToken: String?
    private var storedRefreshToken: String?

    public init(
        accessToken: String? = nil,
        refreshToken: String? = nil
    ) {
        self.storedAccessToken = accessToken
        self.storedRefreshToken = refreshToken
    }

    public func accessToken() async -> String? {
        storedAccessToken
    }

    public func refreshToken() async -> String? {
        storedRefreshToken
    }

    public func save(accessToken: String, refreshToken: String?) async {
        storedAccessToken = accessToken

        if let refreshToken {
            storedRefreshToken = refreshToken
        }
    }
}

public final class MockURLProtocol: URLProtocol {
    public static var responseHandler: ((URLRequest) throws -> HTTPURLResponse)?
    public static var dataHandler: ((URLRequest) throws -> Data)?

    public static func reset() {
        responseHandler = nil
        dataHandler = nil
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    public override func startLoading() {
        guard let responseHandler = Self.responseHandler else {
            client?.urlProtocol(self, didFailWithError: CoreNetworkTestingError.failed)
            return
        }

        do {
            let response = try responseHandler(request)
            let data = try Self.dataHandler?(request) ?? Data()

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    public override func stopLoading() {}
}
