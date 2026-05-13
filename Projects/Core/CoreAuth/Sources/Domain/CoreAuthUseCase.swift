//
//  CoreAuthUseCase.swift
//  CoreAuth
//
//  Created by 김동준 on 5/13/26
//  Copyright © 2026 QCells. All rights reserved.
//

import CoreAuthInterface
import Domain

public struct CoreAuthUseCase: CoreAuthInterface {
    private let repository: CoreAuthRepositoryProtocol

    public init(repository: CoreAuthRepositoryProtocol) {
        self.repository = repository
    }

    public func getUserProfile() async throws -> UserProfile {
        try await repository.getUserProfile()
    }
}
