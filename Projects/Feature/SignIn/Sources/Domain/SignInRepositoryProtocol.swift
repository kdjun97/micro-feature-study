public protocol SignInRepositoryProtocol {
    func signIn() async throws -> Bool
}
