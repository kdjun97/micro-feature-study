//
//  DetailRoute+.swift
//  Main
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import DetailInterface

extension MainCoordinator: DetailRouting {
    public func route(from route: DetailRoute) {
        switch route {
        case .logout:
            delegate?.mainCoordinatorDidRequestLogout(self)
        }
    }
}
