import XCTest
@testable import Dashboard
import DashboardInterface
import DashboardTesting

final class HomeViewModelTests: XCTestCase {
    func testButtonTappedEmitsPushDetail() {
        let viewModel = HomeViewModel()
        var didEmitPushDetail = false

        viewModel.onOutput = { output in
            if case .onPushDetail = output {
                didEmitPushDetail = true
            }
        }

        viewModel.send(.buttonTapped)

        XCTAssertTrue(didEmitPushDetail)
    }

    func testAlertButtonTappedEmitsAlertCase() {
        let viewModel = HomeViewModel()
        var receivedAlertCase: HomeAlertCase?

        viewModel.onOutput = { output in
            if case .showAlert(let alertCase) = output {
                receivedAlertCase = alertCase
            }
        }

        viewModel.send(.alertButtonTapped(.tip))

        XCTAssertEqual(receivedAlertCase, .tip)
    }

    func testDismissAlertEmitsNilAlert() {
        let viewModel = HomeViewModel()
        var didEmitDismiss = false

        viewModel.onOutput = { output in
            if case .showAlert(let alertCase) = output, alertCase == nil {
                didEmitDismiss = true
            }
        }

        viewModel.send(.dismissAlert)

        XCTAssertTrue(didEmitDismiss)
    }
}
