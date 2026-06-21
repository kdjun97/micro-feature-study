import CoreAuth
import CoreAuthInterface
import CoreKeyChainStorage
import CoreKeyChainStorageInterface
import CoreNetwork
import CoreNetworkInterface
import Swinject

extension AppAssembly {
    func assembleCore(in container: Container) {
        container.register(CoreKeyChainStorageProtocol.self) { _ in
            CoreKeyChainStorage()
        }

        container.register(CoreTokenStorage.self) { resolver in
            let keyChainStorage: CoreKeyChainStorageProtocol = resolver.resolve()
            return CoreTokenStorageAdapter(keyChainStorage: keyChainStorage)
        }

        container.register(CoreNetworkProtocol.self) { resolver in
            let tokenStore: CoreTokenStorage = resolver.resolve()
            return CoreNetworkClient(
                tokenStore: tokenStore,
                refreshTokenEndpoint: CoreNetworkEndpoint(
                    path: .refreshToken,
                    method: .POST,
                    requiresAuthorization: false
                )
            )
        }
        .inObjectScope(.container)

        container.register(CoreAuthRepositoryProtocol.self) { resolver in
            let networkClient: CoreNetworkProtocol = resolver.resolve()
            return CoreAuthRepository(networkClient: networkClient)
        }

        container.register(CoreAuthInterface.self) { resolver in
            let repository: CoreAuthRepositoryProtocol = resolver.resolve()
            return CoreAuthUseCase(repository: repository)
        }
    }
}
