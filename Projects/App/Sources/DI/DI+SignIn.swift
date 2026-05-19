//
//  DI+SignIn.swift
//  MicroFeatureStudy
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import SignIn
import CoreAuthInterface
import CoreNetworkInterface
import SignInInterface

extension DIContainer {
    func registerSignInDependencies() {
        container.register(SignInRepositoryProtocol.self) { resolver in
            guard let networkClient = resolver.resolve(CoreNetworkProtocol.self) else {
                fatalError("SignInRepositoryProtocol dependencies are not registered.")
            }
            return SignInRepository(networkClient: networkClient)
        }

        container.register(SignInUseCaseProtocol.self) { resolver in
            SignInUseCase(
                repository: resolver.resolve(SignInRepositoryProtocol.self)!
            )
        }

        container.register(SignInBuildable.self) { resolver in
            SignInBuilder(
                useCase: resolver.resolve(SignInUseCaseProtocol.self)!,
                coreAuthUseCase: resolver.resolve(CoreAuthInterface.self)!
            )
        }
    }
}
