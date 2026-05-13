import Domain

public protocol CoreAuthInterface {
    func getUserProfile() async throws -> UserProfile
}
