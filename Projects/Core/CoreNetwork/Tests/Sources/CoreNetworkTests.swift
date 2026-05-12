import CoreNetworkInterface
import CoreNetworkTesting
import XCTest
@testable import CoreNetwork

final class DefaultCoreNetworkClientTests: XCTestCase {
    func testRequestReturnsSuccessResponse() async throws {
        let client = CoreNetworkClient(delayNanoseconds: 0)

        let response = try await client.request(
            CoreNetworkEndpoint(path: "/health")
        )

        XCTAssertTrue(response.isSuccess)
    }
}

final class StubCoreNetworkClientTests: XCTestCase {
    func testStubRecordsEndpointAndReturnsConfiguredResponse() async throws {
        let client = StubCoreNetworkClient(
            response: CoreNetworkResponse(isSuccess: false)
        )
        let endpoint = CoreNetworkEndpoint(path: "/sign-in", method: "POST")

        let response = try await client.request(endpoint)

        XCTAssertFalse(response.isSuccess)
        XCTAssertEqual(client.receivedEndpoints, [endpoint])
    }

    func testStubThrowsConfiguredErrorAndRecordsEndpoint() async {
        let client = StubCoreNetworkClient(error: CoreNetworkTestingError.failed)
        let endpoint = CoreNetworkEndpoint(path: "/failure")

        do {
            _ = try await client.request(endpoint)
            XCTFail("Expected request to throw.")
        } catch {
            XCTAssertEqual(client.receivedEndpoints, [endpoint])
        }
    }
}
