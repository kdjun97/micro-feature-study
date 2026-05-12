//
//  RootCoordinatorView.swift
//  Root
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import SwiftUI

public struct RootCoordinatorView: View {
    @StateObject private var coordinator: RootCoordinator

    public init(coordinator: RootCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeRootView()
                .navigationDestination(for: RootDestination.self) { destination in
                    coordinator.makeDestinationView(destination)
                }
        }
    }
}
