//
//  DashboardRoute+.swift
//  Root
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import DashboardInterface

extension RootCoordinator: DashboardRouting {
    public func route(from route: DashboardRoute) {
        switch route {
        case .backRequested:
            if !signInPath.isEmpty {
                signInPath.removeLast()
            }
        }
    }
}
