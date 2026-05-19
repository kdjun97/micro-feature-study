import CoreKeyChainStorageInterface

public struct CoreKeyChainStorage: CoreKeyChainStorageProtocol {
    public init() {}
    
    public func read(key: String) async throws -> String? {
        return nil
    }
    
    public func save(_ value: String, key: String) async throws {
        
    }
    
    public func remove(key: String) async throws {
        
    }
}
