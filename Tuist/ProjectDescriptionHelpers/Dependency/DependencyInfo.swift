//
//  DependencyInfo.swift
//  BaseTemplateManifests
//
//  Created by 김동준 on 9/7/25
//

public struct DependencyInfo: @unchecked Sendable {
    let moduleDependencies: [Module: [Dependency]]
    let microFeatureDependencies: [MicroFeatureModule: MicroFeatureDependencies]
}

public enum Dependency {
    case module(Module)
    case external(ExternalModule)
    case microFeature(MicroFeatureModule)
}

public struct MicroFeatureDependencies {
    let interface: [Dependency]
    let implementation: [Dependency]
    let testing: [Dependency]
    let tests: [Dependency]
    let demo: [Dependency]
    
    public init(
        interface: [Dependency] = [],
        implementation: [Dependency] = [],
        testing: [Dependency] = [],
        tests: [Dependency] = [],
        demo: [Dependency] = []
    ) {
        self.interface = interface
        self.implementation = implementation
        self.testing = testing
        self.tests = tests
        self.demo = demo
    }
}

public let dependencyInfo: DependencyInfo = DependencyInfo(
    moduleDependencies: [
        .App: [
            .module(.Root),
            .module(.Main),
            .microFeature(.CoreNetwork),
            .microFeature(.CoreAuth),
            .module(.MicroFeature(.CoreNetwork)),
            .module(.MicroFeature(.CoreAuth)),
            .module(.MicroFeature(.SignIn)),
            .module(.MicroFeature(.Dashboard)),
            .module(.MicroFeature(.Detail)),
            .external(.Swinject)
        ],
        .Root: [
            .module(.Main),
            .microFeature(.SignIn),
            .microFeature(.Dashboard)
        ],
        .Main: [
            .microFeature(.Detail)
        ]
    ],
    microFeatureDependencies: [
        .SignIn: .init(
            implementation: [
                .microFeature(.CoreNetwork),
                .microFeature(.CoreAuth)
            ],
            demo: [.microFeature(.CoreAuth)]
        ),
        .Dashboard: .init(),
        .Detail: .init(
            implementation: [
                .microFeature(.CoreNetwork),
                .microFeature(.CoreAuth)
            ]
        ),
        .CoreAuth: .init(
            interface: [.module(.Domain)],
            implementation: [
                .module(.Domain),
                .microFeature(.CoreNetwork)
            ],
            testing: [.module(.Domain)]
        )
    ]
)
