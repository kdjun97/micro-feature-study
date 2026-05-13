//
//  UserProfile.swift
//  Domain
//
//  Created by 김동준 on 5/13/26
//  Copyright © 2026 QCells. All rights reserved.
//

public struct UserProfile: Equatable {
    public let id: String
    public let name: String
    public let age: Int
    public let email: String
    
    public init(
        id: String,
        name: String,
        age: Int,
        email: String
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.email = email
    }
}
