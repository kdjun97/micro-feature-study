import CoreNetworkInterface
import Foundation

public struct CoreNetworkClient: CoreNetworkProtocol {
    private let delayNanoseconds: UInt64

    public init(delayNanoseconds: UInt64 = 1_000_000_000) {
        self.delayNanoseconds = delayNanoseconds
    }

    public func request(_ endpoint: CoreNetworkEndpoint) async throws -> CoreNetworkResponse {
        if delayNanoseconds > 0 {
            try await Task.sleep(nanoseconds: delayNanoseconds)
        }

        return CoreNetworkResponse(isSuccess: true)
    }
}
