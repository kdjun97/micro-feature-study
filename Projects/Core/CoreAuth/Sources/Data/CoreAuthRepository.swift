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
        let response: UserProfileResponseDTO = try await networkClient.request(
            CoreNetworkEndpoint(
                path: .profile,
                method: .GET
            )
        )

        return UserProfile(
            id: response.id,
            name: response.name,
            age: response.age,
            email: response.email
        )
    }
}

private struct UserProfileResponseDTO: Decodable {
    let id: String
    let name: String
    let age: Int
    let email: String
}
