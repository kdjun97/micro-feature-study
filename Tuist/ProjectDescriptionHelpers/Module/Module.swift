//
//  Module.swift
//  BaseTemplateManifests
//
//  Created by 김동준 on 9/7/25
//

public enum Module: Hashable {
    case Main
    case Root
    case Domain
    case App
    case DesignSystem
    case External(ExternalModule)
    case MicroFeature(MicroFeatureModule)
}

public enum ExternalModule {
    case Swinject
    
    var name: String {
        switch self {
        default: "\(self)"
        }
    }
}

public enum MicroFeatureModule {
    case CoreAuth
    case Detail
    case Dashboard
    case SignIn
    case CoreNetwork
    
    var name: String {
        switch self {
        default: "\(self)"
        }
    }
    
    var interfaceName: String { "\(name)Interface" }
    var testingName: String { "\(name)Testing" }
    var testsName: String { "\(name)Tests" }
    var demoName: String { "\(name)Demo" }
    
    var bundleID: String {
        let organizationName = projectEnvironment.organizationName
        let appName = projectEnvironment.appName
        return "com.\(organizationName).\(appName).\(name.lowercased())"
    }
    
    var path: String {
        switch self {
        case .SignIn: "Projects/Feature/SignIn"
        case .Dashboard: "Projects/Feature/Dashboard"
        case .Detail: "Projects/Feature/Detail"
        case .CoreNetwork: "Projects/Core/CoreNetwork"
        case .CoreAuth: "Projects/Core/CoreAuth"
        }
    }
}
