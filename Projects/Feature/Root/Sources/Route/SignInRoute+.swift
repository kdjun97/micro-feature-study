//
//  SignInRoute+.swift
//  Root
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import SignInInterface

extension RootCoordinator: SignInRouting {
    public func route(from route: SignInRoute) {
        switch route {
        case .signInSucceeded:
            mainCoordinator.startDetail()
            path.removeAll()
            root = .main
        case .dashboardRequested:
            path.append(.dashboard)
        }
    }
}
