import XCTest
@testable import Dashboard
import DashboardInterface
import DashboardTesting

final class HomeViewModelTests: XCTestCase {
    func testButtonTappedEmitsPushDetail() {
        let viewModel = HomeViewModel()
        var didEmitPushDetail = false

        viewModel.onRoute = { route in
            if case .detailRequested = route {
                didEmitPushDetail = true
            }
        }

        viewModel.send(.buttonTapped)

        XCTAssertTrue(didEmitPushDetail)
    }

    func testAlertButtonTappedEmitsAlertRequestedRoute() {
        let viewModel = HomeViewModel()
        var receivedAlertEvent: DashboardAlertEvent?

        viewModel.onRoute = { route in
            if case .alertRequested(let event) = route {
                receivedAlertEvent = event
            }
        }

        viewModel.send(.alertButtonTapped(.tip))

        XCTAssertEqual(receivedAlertEvent, .tip)
    }
}
