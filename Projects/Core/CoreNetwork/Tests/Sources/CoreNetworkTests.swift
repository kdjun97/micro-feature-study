import CoreNetworkInterface
import CoreNetworkTesting
import XCTest
@testable import CoreNetwork

final class DefaultCoreNetworkClientTests: XCTestCase {
    func testRequestThrowsNotImplementedUntilTransportIsAdded() async {
        let client = CoreNetworkClient()

        do {
            let _: TestResponseDTO = try await client.request(
                CoreNetworkEndpoint(path: "/health")
            )
            XCTFail("Expected request to throw.")
        } catch CoreNetworkClientError.notImplemented {
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
        let endpoint = CoreNetworkEndpoint(path: "/sign-in", method: "POST")

        let response: TestResponseDTO = try await client.request(endpoint)

        XCTAssertFalse(response.isSuccess)
        XCTAssertEqual(client.receivedEndpoints, [endpoint])
    }

    func testStubThrowsConfiguredErrorAndRecordsEndpoint() async {
        let client = StubCoreNetworkClient(error: CoreNetworkTestingError.failed)
        let endpoint = CoreNetworkEndpoint(path: "/failure")

        do {
            let _: TestResponseDTO = try await client.request(endpoint)
            XCTFail("Expected request to throw.")
        } catch {
            XCTAssertEqual(client.receivedEndpoints, [endpoint])
        }
    }
}

private struct TestResponseDTO: Decodable, Equatable {
    let isSuccess: Bool
}
