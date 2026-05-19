import XCTest
@testable import Dashboard
import DashboardInterface
import DashboardTesting

@MainActor
final class DashboardViewModelTests: XCTestCase {
    func testInitialTitleUsesUseCaseTitle() {
        let useCase = MockDashboardUseCase()
        let router = MockDashboardRouter()

        let viewModel = DashboardViewModel(
            useCase: useCase,
            router: router
        )

        XCTAssertEqual(viewModel.title, "Mock Dashboard")
    }

    func testBackButtonRoutesToBackRequested() {
        let useCase = MockDashboardUseCase()
        let router = MockDashboardRouter()
        let viewModel = DashboardViewModel(
            useCase: useCase,
            router: router
        )

        viewModel.backButtonTapped()

        XCTAssertEqual(router.routes, [.backRequested])
    }
}
