//
//  DI+Detail.swift
//  MicroFeatureStudy
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import CoreAuthInterface
import CoreNetworkInterface
import Detail
import DetailInterface

extension DIContainer {
    func registerDetailDependencies() {
        container.register(DetailRepositoryProtocol.self) { resolver in
            guard let networkClient = resolver.resolve(CoreNetworkProtocol.self) else {
                fatalError("DetailRepositoryProtocol dependencies are not registered.")
            }
            return DetailRepository(networkClient: networkClient)
        }

        container.register(DetailUseCaseProtocol.self) { resolver in
            DetailUseCase(
                repository: resolver.resolve(DetailRepositoryProtocol.self)!
            )
        }

        container.register(DetailBuildable.self) { resolver in
            guard let useCase = resolver.resolve(DetailUseCaseProtocol.self) else {
                fatalError("DetailUseCaseProtocol dependencies are not registered.")
            }

            return DetailBuilder(
                useCase: useCase,
                coreAuthUseCase: resolver.resolve(CoreAuthInterface.self)!
            )
        }
    }
}
