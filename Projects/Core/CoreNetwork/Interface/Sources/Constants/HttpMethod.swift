//
//  HttpMethod.swift
//  CoreNetworkInterface
//
//  Created by 김동준 on 5/18/26
//

public enum HttpMethod: String, Equatable, Sendable {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case HEAD = "HEAD"
}
