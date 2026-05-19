//
//  DI+CoreAuth.swift
//  MicroFeatureStudy
//
//  Created by 김동준 on 5/13/26
//  Copyright © 2026 QCells. All rights reserved.
//

import CoreAuth
import CoreAuthInterface
import CoreNetworkInterface

extension DIContainer {
    func registerCoreAuthDependencies() {
        container.register(CoreAuthRepositoryProtocol.self) { resolver in
            guard let networkClient = resolver.resolve(CoreNetworkProtocol.self) else {
                fatalError("CoreAuthRepositoryProtocol dependencies are not registered.")
            }

            return CoreAuthRepository(networkClient: networkClient)
        }

        container.register(CoreAuthInterface.self) { resolver in
            CoreAuthUseCase(
                repository: resolver.resolve(CoreAuthRepositoryProtocol.self)!
            )
        }
    }
}
