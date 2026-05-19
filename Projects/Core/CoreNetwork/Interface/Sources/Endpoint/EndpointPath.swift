//
//  EndpointPath.swift
//  CoreNetwork
//
//  Created by 김동준 on 5/18/26
//

public enum EndpointPath: Equatable, Sendable {
    case signIn
    case logout
    case profile
    case refreshToken

    public var value: String {
        switch self {
        case .signIn:
            "/signIn"
        case .logout:
            "/logout"
        case .profile:
            "/profile"
        case .refreshToken:
            "/auth/refresh"
        }
    }
}
