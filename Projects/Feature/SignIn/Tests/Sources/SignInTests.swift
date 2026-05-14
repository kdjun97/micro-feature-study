import XCTest
import CoreAuthTesting
import CoreNetworkInterface
@testable import SignIn
import SignInInterface
import SignInTesting

@MainActor
final class SignInViewModelTests: XCTestCase {
    func testInitialStateShowsNormalStatus() {
        let useCase = MockSignInUseCase.success()
        let router = MockSignInRouter()
        let viewModel = SignInViewModel(
            useCase: useCase,
            coreAuthUseCase: MockCoreAuthUseCase.success(),
            router: router
        )

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "상태: 노말")
        XCTAssertEqual(viewModel.userProfileMessage, "유저: 없음")
    }

    func testSignInButtonShowsLoadingAndRoutesToSuccessWhenUseCaseSucceeds() async {
        let useCase = MockSignInUseCase.success()
        let router = MockSignInRouter()
        let viewModel = SignInViewModel(
            useCase: useCase,
            coreAuthUseCase: MockCoreAuthUseCase.success(),
            router: router
        )

        let task = Task {
            await viewModel.signInButtonTapped()
        }

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "상태: 로딩")

        await task.value

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "상태: 노말")
        XCTAssertEqual(viewModel.userProfileMessage, "유저: Jumy")
        XCTAssertEqual(router.routes, [.signInSucceeded])
    }

    func testSignInButtonShowsFailureMessageAndDoesNotRouteWhenUseCaseFails() async {
        let useCase = MockSignInUseCase.failure()
        let router = MockSignInRouter()
        let viewModel = SignInViewModel(
            useCase: useCase,
            coreAuthUseCase: MockCoreAuthUseCase.success(),
            router: router
        )

        await viewModel.signInButtonTapped()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "상태: 로그인 실패")
        XCTAssertEqual(router.routes, [])
    }

    func testDashboardButtonRoutesToDashboard() {
        let useCase = MockSignInUseCase.success()
        let router = MockSignInRouter()
        let viewModel = SignInViewModel(
            useCase: useCase,
            coreAuthUseCase: MockCoreAuthUseCase.success(),
            router: router
        )

        viewModel.dashboardButtonTapped()

        XCTAssertEqual(router.routes, [.dashboardRequested])
    }
}

final class SignInUseCaseTests: XCTestCase {
    func testSignInReturnsRepositorySuccess() async {
        let repository = MockSignInRepository(result: .success(true))
        let useCase = SignInUseCase(repository: repository)

        let result = await useCase.signIn()

        XCTAssertTrue(result)
    }

    func testSignInReturnsFalseWhenRepositoryFails() async {
        let repository = MockSignInRepository(result: .failure(SignInTestError.failed))
        let useCase = SignInUseCase(repository: repository)

        let result = await useCase.signIn()

        XCTAssertFalse(result)
    }
}

final class SignInRepositoryTests: XCTestCase {
    func testSignInRequestsSignInEndpointAndReturnsNetworkSuccess() async throws {
        let networkClient = StubCoreNetworkClient(
            response: CoreNetworkResponse(isSuccess: true)
        )
        let repository = SignInRepository(networkClient: networkClient)

        let result = try await repository.signIn()

        XCTAssertTrue(result)
        XCTAssertEqual(
            networkClient.receivedEndpoints,
            [
                CoreNetworkEndpoint(
                    path: "/sign-in",
                    method: "POST"
                )
            ]
        )
    }
}

private enum SignInTestError: Error {
    case failed
}

struct MockSignInRepository: SignInRepositoryProtocol {
    private let result: Result<Bool, Error>

    public init(result: Result<Bool, Error> = .success(true)) {
        self.result = result
    }

    public func signIn() async throws -> Bool {
        return try result.get()
    }
}
