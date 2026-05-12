//
//  MainCoordinatorDelegate+.swift
//  Root
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import Main

extension RootCoordinator: @MainActor MainCoordinatorDelegate {
    public func mainCoordinatorDidRequestLogout(_ coordinator: MainCoordinator) {
        moveToSignIn()
    }
    
    private func moveToSignIn() {
        destination = .signIn
    }
}
