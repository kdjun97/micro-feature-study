//
//  MainCoordinatorView.swift
//  Main
//
//  Created by 김동준 on 5/12/26
//  Copyright © 2026 QCells. All rights reserved.
//

import SwiftUI

public struct MainCoordinatorView: View {
    @StateObject private var coordinator: MainCoordinator

    public init(coordinator: MainCoordinator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeRootView()
                .navigationDestination(for: MainDestination.self) { destination in
                    coordinator.makeDestinationView(destination)
                }
        }
    }
}
