import CoreKeyChainStorageInterface
import CoreNetworkInterface
import Swinject

extension DIContainer {
    func makeCoreTokenStorageAdapter(_ resolver: Resolver) -> CoreTokenStorage? {
        guard let keyChainStorage = resolver.resolve(CoreKeyChainStorageProtocol.self) else {
            return nil
        }

        return CoreTokenStorageAdapter(keyChainStorage: keyChainStorage)
    }
    
}
