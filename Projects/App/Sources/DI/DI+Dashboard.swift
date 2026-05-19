//
//  DI+Dashboard.swift
//  MicroFeatureStudy
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import Dashboard
import DashboardInterface

extension DIContainer {
    func registerDashboardDependencies() {
        container.register(DashboardUseCaseProtocol.self) { _ in
            DashboardUseCase()
        }

        container.register(DashboardBuildable.self) { resolver in
            guard let useCase = resolver.resolve(DashboardUseCaseProtocol.self) else {
                fatalError("DashboardUseCase dependencies are not registered.")
            }
            
            return DashboardBuilder(useCase: useCase)
        }
    }
}
