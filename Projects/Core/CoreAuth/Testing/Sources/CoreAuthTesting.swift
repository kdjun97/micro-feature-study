import CoreAuthInterface
import Domain

public struct CoreAuthTesting {
    public init() {}
}

public enum CoreAuthTestingError: Error {
    case failed
}

public struct MockCoreAuthUseCase: CoreAuthInterface {
    private let result: Result<UserProfile, Error>

    public init(result: Result<UserProfile, Error>) {
        self.result = result
    }

    public static func success(
        profile: UserProfile = UserProfile(
            id: "1",
            name: "Jumy",
            age: 20,
            email: "jumy@example.com"
        )
    ) -> MockCoreAuthUseCase {
        MockCoreAuthUseCase(result: .success(profile))
    }

    public static func failure(
        error: Error = CoreAuthTestingError.failed
    ) -> MockCoreAuthUseCase {
        MockCoreAuthUseCase(result: .failure(error))
    }

    public func getUserProfile() async throws -> UserProfile {
        try result.get()
    }
}
