import SwiftUI
import Dashboard
import DashboardTesting

@main
struct DashboardDemoApp: App {
    private let viewModel: DashboardViewModel

    init() {
        self.viewModel = DashboardViewModel(
            useCase: MockDashboardUseCase(),
            router: MockDashboardRouter()
        )
    }

    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: viewModel)
        }
    }
}
