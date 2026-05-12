import SignInInterface
import SignIn

public struct SignInTesting {
    public init() {}
}

public struct MockSignInUseCase: SignInUseCaseProtocol {
    private let result: Bool

    private init(result: Bool) {
        self.result = result
    }

    public static func success() -> MockSignInUseCase {
        MockSignInUseCase(result: true)
    }

    public static func failure() -> MockSignInUseCase {
        MockSignInUseCase(result: false)
    }

    public func signIn() async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return result
    }
}

public final class MockSignInRepository: SignInRepositoryProtocol {
    private let result: Result<Bool, Error>
    
    public init(result: Result<Bool, Error> = .success(true)) {
        self.result = result
    }

    public func signIn() async throws -> Bool {
        return try result.get()
    }
}

@MainActor
public final class MockSignInRouter: SignInRouting {
    public private(set) var routes: [SignInRoute] = []

    public init() {}

    public func route(from route: SignInRoute) {
        routes.append(route)
    }
}
