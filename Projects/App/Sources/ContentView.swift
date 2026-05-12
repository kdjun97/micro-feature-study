//
//  ContentView.swift
//  MicroFeature
//
//  Created by 김동준 on 9/7/25
//

import SwiftUI
import Root

@main
struct MicroFeatureStudyApp: App {
    private let container = DIContainer()

    var body: some Scene {
        WindowGroup {
            RootCoordinatorView(coordinator: container.makeRootCoordinator())
        }
    }
}
