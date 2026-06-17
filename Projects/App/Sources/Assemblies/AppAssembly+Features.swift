import CoreAuthInterface
import CoreNetworkInterface
import Dashboard
import DashboardInterface
import Detail
import DetailInterface
import SignIn
import SignInInterface
import Swinject

extension AppAssembly {
    func assembleFeatures(in container: Container) {
        assembleSignInFeature(in: container)
        assembleDashboardFeature(in: container)
        assembleDetailFeature(in: container)
    }
}

private extension AppAssembly {
    func assembleSignInFeature(in container: Container) {
        container.register(SignInRepositoryProtocol.self) { resolver in
            let networkClient: CoreNetworkProtocol = resolver.resolve()
            return SignInRepository(networkClient: networkClient)
        }

        container.register(SignInUseCaseProtocol.self) { resolver in
            let repository: SignInRepositoryProtocol = resolver.resolve()
            return SignInUseCase(repository: repository)
        }

        container.register(SignInBuildable.self) { resolver in
            let useCase: SignInUseCaseProtocol = resolver.resolve()
            let coreAuthUseCase: CoreAuthInterface = resolver.resolve()
            return SignInBuilder(
                useCase: useCase,
                coreAuthUseCase: coreAuthUseCase
            )
        }
    }

    func assembleDashboardFeature(in container: Container) {
        container.register(DashboardUseCaseProtocol.self) { _ in
            DashboardUseCase()
        }

        container.register(DashboardBuildable.self) { resolver in
            let useCase: DashboardUseCaseProtocol = resolver.resolve()
            return DashboardBuilder(useCase: useCase)
        }
    }

    func assembleDetailFeature(in container: Container) {
        container.register(DetailRepositoryProtocol.self) { resolver in
            let networkClient: CoreNetworkProtocol = resolver.resolve()
            return DetailRepository(networkClient: networkClient)
        }

        container.register(DetailUseCaseProtocol.self) { resolver in
            let repository: DetailRepositoryProtocol = resolver.resolve()
            return DetailUseCase(repository: repository)
        }

        container.register(DetailBuildable.self) { resolver in
            let useCase: DetailUseCaseProtocol = resolver.resolve()
            let coreAuthUseCase: CoreAuthInterface = resolver.resolve()
            return DetailBuilder(
                useCase: useCase,
                coreAuthUseCase: coreAuthUseCase
            )
        }
    }
}
