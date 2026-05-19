//
//  DI+CoreNetwork.swift
//  MicroFeatureStudy
//
//  Created by 김동준 on 5/19/26
//  Copyright © 2026 QCells. All rights reserved.
//

import CoreNetworkInterface
import CoreNetwork

extension DIContainer {
    func registerCoreNetworkDependencies() {
        container.register(CoreNetworkProtocol.self) { resolver in
            return CoreNetworkClient(
                tokenStore: self.makeCoreTokenStorageAdapter(resolver),
                refreshTokenEndpoint: CoreNetworkEndpoint(
                    path: .refreshToken,
                    method: .POST,
                    requiresAuthorization: false
                )
            )
        }
    }
}
