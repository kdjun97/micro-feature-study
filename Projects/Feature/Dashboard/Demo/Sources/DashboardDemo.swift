import SwiftUI
import Dashboard
import DashboardTesting

@main
struct DashboardDemoApp: App {
    private let useCase: DashboardUseCaseProtocol
    private let viewModel: DashboardViewModel

    init() {
        self.useCase = MockDashboardUseCase()
        self.viewModel = DashboardViewModel(
            useCase: useCase,
            router: MockDashboardRouter()
        )
    }

    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: viewModel)
        }
    }
}
