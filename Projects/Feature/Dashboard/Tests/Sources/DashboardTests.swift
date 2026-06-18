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

    func testAlertButtonTappedEmitsAlertCase() {
        let viewModel = HomeViewModel()
        var receivedAlertCase: HomeAlertCase?

        viewModel.onViewState = { viewState in
            if case .showAlert(let alertCase) = viewState {
                receivedAlertCase = alertCase
            }
        }

        viewModel.send(.alertButtonTapped(.tip))

        XCTAssertEqual(receivedAlertCase, .tip)
    }

    func testDismissAlertEmitsNilAlert() {
        let viewModel = HomeViewModel()
        var didEmitDismiss = false

        viewModel.onViewState = { viewState in
            if case .showAlert(let alertCase) = viewState, alertCase == nil {
                didEmitDismiss = true
            }
        }

        viewModel.send(.dismissAlert)

        XCTAssertTrue(didEmitDismiss)
    }
}
