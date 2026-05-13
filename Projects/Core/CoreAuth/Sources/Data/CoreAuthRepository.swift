//
//  CoreAuthRepository.swift
//  CoreAuth
//
//  Created by 김동준 on 5/13/26
//  Copyright © 2026 QCells. All rights reserved.
//

import CoreNetworkInterface
import Domain

public struct CoreAuthRepository: CoreAuthRepositoryProtocol {
    private let networkClient: CoreNetworkProtocol

    public init(networkClient: CoreNetworkProtocol) {
        self.networkClient = networkClient
    }

    public func getUserProfile() async throws -> UserProfile {
        do {
            let response = try await networkClient.request(
                CoreNetworkEndpoint(
                    path: "/profile",
                    method: "GET"
                )
            )

            // TODO: Mapper 구현 + CoreNetwork Generic 구현 필요 / 일단 지금은 검증만
            return .init(id: "2", name: "s", age: 1, email: ":D")
        } catch {
            throw error
        }
    }
}
