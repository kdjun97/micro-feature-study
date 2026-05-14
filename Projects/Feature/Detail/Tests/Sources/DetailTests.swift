import XCTest
import CoreAuthTesting
import CoreNetworkInterface
@testable import Detail
import DetailInterface
import DetailTesting

@MainActor
final class DetailViewModelTests: XCTestCase {
    func testInitialTitleUsesUseCaseTitle() {
        let useCase = MockDetailUseCase(title: "Mock Detail")
        let router = MockDetailRouter()

        let viewModel = DetailViewModel(
            useCase: useCase,
            coreAuthUseCase: MockCoreAuthUseCase.success(),
            router: router
        )

        XCTAssertEqual(useCase.titleCallCount, 1)
        XCTAssertEqual(viewModel.title, "Mock Detail")
        XCTAssertEqual(viewModel.logoutMessage, "상태: 노말")
        XCTAssertEqual(viewModel.userProfileMessage, "유저: 없음")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLogoutFailedAlertPresented)
        XCTAssertEqual(router.routes, [])
    }

    func testLogoutButtonShowsLoadingAndRoutesToLogoutWhenUseCaseSucceeds() async {
        let useCase = MockDetailUseCase(logoutResult: true)
        let router = MockDetailRouter()
        let viewModel = DetailViewModel(
            useCase: useCase,
            coreAuthUseCase: MockCoreAuthUseCase.success(),
            router: router
        )

        let task = Task {
            await viewModel.logoutButtonTapped()
        }

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.logoutMessage, "상태: 로그아웃 중")

        await task.value

        XCTAssertEqual(useCase.logoutCallCount, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.logoutMessage, "상태: 노말")
        XCTAssertEqual(viewModel.userProfileMessage, "유저: Jumy")
        XCTAssertFalse(viewModel.isLogoutFailedAlertPresented)
        XCTAssertEqual(router.routes, [.logout])
    }

    func testLogoutButtonShowsFailureAlertAndDoesNotRouteWhenUseCaseFails() async {
        let useCase = MockDetailUseCase(logoutResult: false)
        let router = MockDetailRouter()
        let viewModel = DetailViewModel(
            useCase: useCase,
            coreAuthUseCase: MockCoreAuthUseCase.success(),
            router: router
        )

        await viewModel.logoutButtonTapped()

        XCTAssertEqual(useCase.logoutCallCount, 1)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.logoutMessage, "상태: 로그아웃 실패")
        XCTAssertTrue(viewModel.isLogoutFailedAlertPresented)
        XCTAssertEqual(router.routes, [])
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
        let networkClient = StubDetailNetworkClient(
            response: CoreNetworkResponse(isSuccess: true)
        )
        let repository = DetailRepository(networkClient: networkClient)

        let result = try await repository.logout()

        XCTAssertTrue(result)
        XCTAssertEqual(
            networkClient.receivedEndpoints,
            [
                CoreNetworkEndpoint(
                    path: "/logout",
                    method: "POST"
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

private final class StubDetailNetworkClient: CoreNetworkProtocol {
    private let result: Result<CoreNetworkResponse, Error>
    private(set) var receivedEndpoints: [CoreNetworkEndpoint] = []

    init(response: CoreNetworkResponse) {
        self.result = .success(response)
    }

    func request(_ endpoint: CoreNetworkEndpoint) async throws -> CoreNetworkResponse {
        receivedEndpoints.append(endpoint)
        return try result.get()
    }
}
