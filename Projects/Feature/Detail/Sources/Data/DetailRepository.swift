import CoreNetworkInterface

public struct DetailRepository: DetailRepositoryProtocol {
    private let networkClient: CoreNetworkProtocol

    public init(networkClient: CoreNetworkProtocol) {
        self.networkClient = networkClient
    }

    public func logout() async throws -> Bool {
        let response = try await networkClient.request(
            CoreNetworkEndpoint(
                path: "/logout",
                method: "POST"
            )
        )

        return response.isSuccess
    }
}
