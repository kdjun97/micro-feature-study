//
//  CoreAuthRepositoryProtocol.swift
//  CoreAuth
//
//  Created by 김동준 on 5/13/26
//  Copyright © 2026 QCells. All rights reserved.
//

import Domain

public protocol CoreAuthRepositoryProtocol {
    func getUserProfile() async throws -> UserProfile
}
