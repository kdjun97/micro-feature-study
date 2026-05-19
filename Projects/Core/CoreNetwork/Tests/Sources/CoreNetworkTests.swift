import CoreNetwork
import CoreNetworkInterface
import CoreNetworkTesting
import XCTest

final class DefaultCoreNetworkClientTests: XCTestCase {
    override func tearDown() {
        MockURLProtocol.reset()
        super.tearDown()
    }

    func testRequestAddsHeadersTokenAndDecodesResponse() async throws {
        let tokenStore = MockCoreNetworkTokenStore(accessToken: "access-token")
        let client = makeClient(
            tokenStore: tokenStore,
            defaultHeaders: ["X-Client": "CoreNetworkTests"]
        )

        MockURLProtocol.responseHandler = { request in
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), "Bearer access-token")
            XCTAssertEqual(request.value(forHTTPHeaderField: "X-Client"), "CoreNetworkTests")
            XCTAssertEqual(request.value(forHTTPHeaderField: "X-Feature"), "SignIn")

            return HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        }
        MockURLProtocol.dataHandler = { _ in
            Data(#"{"isSuccess":true}"#.utf8)
        }

        let response: TestResponseDTO = try await client.request(
            CoreNetworkEndpoint(
                path: .signIn,
                method: .POST,
                headers: ["X-Feature": "SignIn"]
            )
        )

        XCTAssertTrue(response.isSuccess)
    }

    func testRequestRefreshesTokenOnceAndRetriesWhenUnauthorized() async throws {
        let tokenStore = MockCoreNetworkTokenStore(
            accessToken: "expired-access",
            refreshToken: "refresh-token"
        )
        let client = makeClient(
            tokenStore: tokenStore,
            refreshTokenEndpoint: CoreNetworkEndpoint(
                path: .refreshToken,
                method: .POST,
                requiresAuthorization: false
            )
        )

        var requests: [URLRequest] = []
        MockURLProtocol.responseHandler = { request in
            requests.append(request)

            let statusCode: Int
            if request.url?.path == EndpointPath.profile.value, requests.count == 1 {
                statusCode = 401
            } else {
                statusCode = 200
            }

            return HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
        }
        MockURLProtocol.dataHandler = { request in
            if request.url?.path == EndpointPath.refreshToken.value {
                return Data(#"{"accessToken":"new-access","refreshToken":"new-refresh"}"#.utf8)
            }

            return Data(#"{"isSuccess":true}"#.utf8)
        }

        let response: TestResponseDTO = try await client.request(
            CoreNetworkEndpoint(path: .profile)
        )

        XCTAssertTrue(response.isSuccess)
        XCTAssertEqual(
            requests.map { $0.url?.path },
            [
                EndpointPath.profile.value,
                EndpointPath.refreshToken.value,
                EndpointPath.profile.value
            ]
        )
        XCTAssertEqual(requests[0].value(forHTTPHeaderField: "Authorization"), "Bearer expired-access")
        XCTAssertNil(requests[1].value(forHTTPHeaderField: "Authorization"))
        XCTAssertEqual(requests[2].value(forHTTPHeaderField: "Authorization"), "Bearer new-access")

        let savedAccessToken = await tokenStore.accessToken()
        let savedRefreshToken = await tokenStore.refreshToken()

        XCTAssertEqual(savedAccessToken, "new-access")
        XCTAssertEqual(savedRefreshToken, "new-refresh")
    }

    func testRequestThrowsRequestFailedWhenStatusCodeIsNotSuccessful() async {
        let client = makeClient()

        MockURLProtocol.responseHandler = { request in
            HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
        }
        MockURLProtocol.dataHandler = { _ in Data() }

        do {
            let _: TestResponseDTO = try await client.request(
                CoreNetworkEndpoint(path: .logout, requiresAuthorization: false)
            )
            XCTFail("Expected request to throw.")
        } catch CoreNetworkClientError.internalServerError {
            XCTAssertTrue(true)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

final class StubCoreNetworkClientTests: XCTestCase {
    func testStubRecordsEndpointAndReturnsConfiguredResponse() async throws {
        let client = StubCoreNetworkClient(
            response: TestResponseDTO(isSuccess: false)
        )
        let endpoint = CoreNetworkEndpoint(path: .signIn, method: .POST)

        let response: TestResponseDTO = try await client.request(endpoint)

        XCTAssertFalse(response.isSuccess)
        XCTAssertEqual(client.receivedEndpoints, [endpoint])
    }

    func testStubThrowsConfiguredErrorAndRecordsEndpoint() async {
        let client = StubCoreNetworkClient(error: CoreNetworkTestingError.failed)
        let endpoint = CoreNetworkEndpoint(path: .logout)

        do {
            let _: TestResponseDTO = try await client.request(endpoint)
            XCTFail("Expected request to throw.")
        } catch {
            XCTAssertEqual(client.receivedEndpoints, [endpoint])
        }
    }
}

private func makeClient(
    tokenStore: CoreNetworkTokenStore? = nil,
    refreshTokenEndpoint: CoreNetworkEndpoint? = nil,
    defaultHeaders: [String: String] = [:]
) -> CoreNetworkClient {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]

    return CoreNetworkClient(
        baseURL: URL(string: "https://api.example.com")!,
        tokenStore: tokenStore,
        refreshTokenEndpoint: refreshTokenEndpoint,
        defaultHeaders: defaultHeaders,
        sessionConfiguration: configuration
    )
}

private struct TestResponseDTO: Decodable, Equatable {
    let isSuccess: Bool
}
