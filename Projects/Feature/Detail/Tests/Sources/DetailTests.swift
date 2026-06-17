import XCTest
import CoreNetworkInterface
import CoreNetworkTesting
@testable import Detail
import DetailInterface
import DetailTesting

final class DetailViewModelTests: XCTestCase {
    func testSheetButtonTappedEmitsPresentSheet() {
        let viewModel = DetailViewModel()
        var didEmitPresentSheet = false

        viewModel.onOutput = { output in
            if case .onPresentSheet = output {
                didEmitPresentSheet = true
            }
        }

        viewModel.send(.sheetButtonTapped)

        XCTAssertTrue(didEmitPresentSheet)
    }
}

final class DetailUseCaseTests: XCTestCase {
    func testLogoutReturnsRepositorySuccess() async {
        let repository = MockDetailRepository(result: .success(true))
        let useCase = DetailUseCase(repository: repository)

        let result = await useCase.logout()

        XCTAssertTrue(result)
    }

    func testLogoutReturnsFalseWhenRepositoryFails() async {
        let repository = MockDetailRepository(result: .failure(DetailTestError.failed))
        let useCase = DetailUseCase(repository: repository)

        let result = await useCase.logout()

        XCTAssertFalse(result)
    }
}

final class DetailRepositoryTests: XCTestCase {
    func testLogoutRequestsLogoutEndpointAndReturnsNetworkSuccess() async throws {
        let networkClient = StubCoreNetworkClient(
            response: DetailResponseDTO(isSuccess: true)
        )
        let repository = DetailRepository(networkClient: networkClient)

        let result = try await repository.logout()

        XCTAssertTrue(result)
        XCTAssertEqual(
            networkClient.receivedEndpoints,
            [
                CoreNetworkEndpoint(
                    path: .logout,
                    method: .POST
                )
            ]
        )
    }
}

private enum DetailTestError: Error {
    case failed
}

private final class MockDetailRepository: DetailRepositoryProtocol {
    private let result: Result<Bool, Error>

    init(result: Result<Bool, Error> = .success(true)) {
        self.result = result
    }

    func logout() async throws -> Bool {
        try result.get()
    }
}
