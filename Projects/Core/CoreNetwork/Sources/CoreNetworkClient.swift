import Alamofire
import CoreNetworkInterface
import Foundation

public final class CoreNetworkClient: CoreNetworkProtocol {
    let baseURL: URL
    let session: Session
    let requestInterceptor: CoreNetworkRequestInterceptor
    let defaultHeaders: [String: String]
    let decoder: JSONDecoder
    let reachabilityManager: NetworkReachabilityManager?

    public init(
        tokenStore: CoreTokenStorage? = nil,
        refreshTokenEndpoint: CoreNetworkEndpoint? = nil,
        defaultHeaders: [String: String] = [:],
        decoder: JSONDecoder = JSONDecoder()
    ) {
        let baseURL = CoreNetworkBaseURLProvider.current

        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
        self.decoder = decoder
        self.reachabilityManager = NetworkReachabilityManager.default

        let tokenRefresher = Self.makeTokenRefresher(
            baseURL: baseURL,
            tokenStore: tokenStore,
            refreshTokenEndpoint: refreshTokenEndpoint,
            decoder: decoder
        )
        self.requestInterceptor = Self.makeRequestInterceptor(
            tokenStore: tokenStore,
            tokenRefresher: tokenRefresher,
            defaultHeaders: defaultHeaders
        )
        self.session = Self.makeSession()

        startReachabilityMonitoring()
    }

    deinit {
        reachabilityManager?.stopListening()
    }

    public func request<Response: Decodable>(_ endpoint: CoreNetworkEndpoint) async throws -> Response {
        guard reachabilityManager?.isReachable != false else {
            throw CoreNetworkClientError.networkUnreachable
        }

        return try await call(endpoint)
    }
}

private extension CoreNetworkClient {
    static func makeTokenRefresher(
        baseURL: URL,
        tokenStore: CoreTokenStorage?,
        refreshTokenEndpoint: CoreNetworkEndpoint?,
        decoder: JSONDecoder
    ) -> CoreNetworkTokenRefresher? {
        guard let tokenStore, let refreshTokenEndpoint else {
            return nil
        }

        return CoreNetworkTokenRefresher(
            baseURL: baseURL,
            refreshTokenEndpoint: refreshTokenEndpoint,
            tokenStore: tokenStore,
            decoder: decoder
        )
    }

    static func makeRequestInterceptor(
        tokenStore: CoreTokenStorage?,
        tokenRefresher: CoreNetworkTokenRefresher?,
        defaultHeaders: [String: String]
    ) -> CoreNetworkRequestInterceptor {
        CoreNetworkRequestInterceptor(
            tokenStore: tokenStore,
            tokenRefresher: tokenRefresher,
            defaultHeaders: defaultHeaders
        )
    }

    static func makeSession() -> Session {
        Session(
            configuration: makeSessionConfiguration(),
            eventMonitors: [CoreNetworkEventMonitor()]
        )
    }

    static func makeSessionConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 30
        return configuration
    }

    func startReachabilityMonitoring() {
        reachabilityManager?.startListening { status in
            print("[CoreNetwork] Reachability: \(status)")
        }
    }
}
