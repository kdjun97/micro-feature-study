import SignInInterface

public struct SignInUseCase: SignInUseCaseProtocol {
    private let repository: SignInRepositoryProtocol

    public init(repository: SignInRepositoryProtocol) {
        self.repository = repository
    }

    public func signIn() async -> Bool {
        do {
            return try await repository.signIn()
        } catch {
            return false
        }
    }
}
