import CoreNetworkInterface

public struct SignInRepository: SignInRepositoryProtocol {
    private let networkClient: CoreNetworkProtocol

    public init(networkClient: CoreNetworkProtocol) {
        self.networkClient = networkClient
    }

    public func signIn() async throws -> Bool {
        let response = try await networkClient.request(
            CoreNetworkEndpoint(
                path: "/sign-in",
                method: "POST"
            )
        )

        return response.isSuccess
    }
}
