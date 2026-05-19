//
//  CoreTokenStorageAdapter.swift
//  MicroFeatureStudy
//
//  Created by 김동준 on 5/19/26
//  Copyright © 2026 QCells. All rights reserved.
//

import CoreKeyChainStorageInterface
import CoreNetworkInterface

final class CoreTokenStorageAdapter: CoreTokenStorage {
    private let keyChainStorage: CoreKeyChainStorageProtocol

    init(keyChainStorage: CoreKeyChainStorageProtocol) {
        self.keyChainStorage = keyChainStorage
    }

    func accessToken() async -> String? {
        try? await keyChainStorage.read(key: CoreTokenStorageKey.accessToken)
    }

    func refreshToken() async -> String? {
        try? await keyChainStorage.read(key: CoreTokenStorageKey.refreshToken)
    }

    func save(accessToken: String, refreshToken: String?) async {
        try? await keyChainStorage.save(accessToken, key: CoreTokenStorageKey.accessToken)

        if let refreshToken {
            try? await keyChainStorage.save(refreshToken, key: CoreTokenStorageKey.refreshToken)
        }
    }
}

private enum CoreTokenStorageKey {
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
}
