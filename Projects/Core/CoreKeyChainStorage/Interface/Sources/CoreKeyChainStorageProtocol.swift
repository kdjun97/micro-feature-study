public protocol CoreKeyChainStorageProtocol: Sendable {
    func read(key: String) async throws -> String?
    func save(_ value: String, key: String) async throws
    func remove(key: String) async throws
}
