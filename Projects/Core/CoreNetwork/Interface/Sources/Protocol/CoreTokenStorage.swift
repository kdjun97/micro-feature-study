//
//  CoreTokenStorage.swift
//  CoreNetworkInterface
//
//  Created by 김동준 on 5/19/26
//  Copyright © 2026 QCells. All rights reserved.
//

public protocol CoreTokenStorage: Sendable {
    func accessToken() async -> String?
    func refreshToken() async -> String?
    func save(accessToken: String, refreshToken: String?) async
}
