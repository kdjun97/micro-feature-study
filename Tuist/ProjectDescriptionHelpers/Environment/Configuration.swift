//
//  Configuration.swift
//  ProjectDescriptionHelpers
//
//  Created by 김동준 on 9/7/25
//

import ProjectDescription

public extension ConfigurationName {
    static let dev = ConfigurationName.configuration(Environment.dev.name)
    static let int = ConfigurationName.configuration(Environment.int.name)
    static let qa = ConfigurationName.configuration(Environment.qa.name)
    static let stage = ConfigurationName.configuration(Environment.stage.name)
    static let prod = ConfigurationName.configuration(Environment.prod.name)
}

public extension Array where Element == Configuration {
    static let `default`: [Configuration] = [
        .debug(name: .dev, xcconfig: .path(.dev)),
        .debug(name: .int, xcconfig: .path(.int)),
        .debug(name: .qa, xcconfig: .path(.qa)),
        .debug(name: .stage, xcconfig: .path(.stage)),
        .debug(name: .prod, xcconfig: .path(.prod)),
        .release(name: .release, xcconfig: .path(.release))
    ]
}

private extension ProjectDescription.Path {
    static func path(_ configuration: ConfigurationName) -> Self {
        return .relativeToRoot("XCConfig/\(configuration.rawValue).xcconfig")
    }
}
