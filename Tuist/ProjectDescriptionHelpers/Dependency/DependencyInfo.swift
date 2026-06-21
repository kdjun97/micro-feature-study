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
    case microFeature(MicroFeatureModule) // Interface
    case microFeatureTesting(MicroFeatureModule) // Testing
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
            .microFeature(.CoreKeyChainStorage),
            .module(.MicroFeature(.CoreNetwork)),
            .module(.MicroFeature(.CoreAuth)),
            .module(.MicroFeature(.CoreKeyChainStorage)),
            .module(.MicroFeature(.SignIn)),
            .module(.MicroFeature(.Dashboard)),
            .module(.MicroFeature(.Detail)),
            .microFeature(.MyPage),
            .module(.MicroFeature(.MyPage)),
            .external(.Alamofire),
            .external(.Swinject)
        ],
        .Root: [
            .microFeature(.SignIn),
            .module(.Base)
        ],
        .Main: [
            .microFeature(.Dashboard),
            .microFeature(.Detail),
            .microFeature(.MyPage),
            .module(.DesignSystem),
            .module(.Base)
        ],
        .DesignSystem: [
            .external(.SnapKit)
        ],
        .Base: []
    ],
    microFeatureDependencies: [
        .SignIn: .init(
            implementation: [
                .microFeature(.CoreNetwork),
                .microFeature(.CoreAuth),
                .module(.DesignSystem),
                .external(.ReactorKit),
                .external(.RxSwift),
                .external(.RxCocoa),
                .external(.RxRelay),
                .module(.Base)
            ],
            tests: [
                .microFeatureTesting(.CoreNetwork),
                .microFeatureTesting(.CoreAuth)
            ],
            demo: [.microFeatureTesting(.CoreAuth)]
        ),
        .Dashboard: .init(
            implementation: [
                .module(.DesignSystem),
                .module(.Base)
            ]
        ),
        .Detail: .init(
            implementation: [
                .microFeature(.CoreNetwork),
                .microFeature(.CoreAuth),
                .module(.DesignSystem),
                .module(.Base)
            ],
            tests: [
                .microFeatureTesting(.CoreNetwork),
                .microFeatureTesting(.CoreAuth)
            ],
            demo: [.microFeatureTesting(.CoreAuth)]
        ),
        .MyPage: .init(
            implementation: [
                .module(.DesignSystem),
                .external(.ReactorKit),
                .external(.RxSwift),
                .external(.RxCocoa),
                .external(.RxRelay)
            ]
        ),
        .CoreAuth: .init(
            interface: [.module(.Domain)],
            implementation: [
                .module(.Domain),
                .microFeature(.CoreNetwork)
            ],
            testing: [.module(.Domain)]
        ),
        .CoreNetwork: .init(
            implementation: [
                .external(.Alamofire)
            ]
        )
    ]
)
