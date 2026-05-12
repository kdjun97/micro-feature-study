import DetailInterface

public protocol DetailUseCaseProtocol {
    func title() -> String
    func logout() async -> Bool
}

public struct DetailUseCase: DetailUseCaseProtocol {
    private let repository: DetailRepositoryProtocol

    public init(repository: DetailRepositoryProtocol) {
        self.repository = repository
    }

    public func title() -> String {
        "Detail"
    }

    public func logout() async -> Bool {
        do {
            return try await repository.logout()
        } catch {
            return false
        }
    }
}
