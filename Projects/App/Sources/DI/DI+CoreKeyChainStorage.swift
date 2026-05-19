//
//  DI+CoreKeyChainStorage.swift
//  MicroFeatureStudy
//
//  Created by 김동준 on 5/19/26
//  Copyright © 2026 QCells. All rights reserved.
//

import CoreKeyChainStorageInterface
import CoreKeyChainStorage

extension DIContainer {
    func registerKeyChainStorageDependencies() {
        container.register(CoreKeyChainStorageProtocol.self) { resolver in
            return CoreKeyChainStorage()
        }
    }
}
