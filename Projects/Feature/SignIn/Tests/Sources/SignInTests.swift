import XCTest
import RxSwift
import CoreNetworkInterface
import CoreNetworkTesting
@testable import SignIn
import SignInInterface
import SignInTesting

final class SignInReactorTests: XCTestCase {
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testMainButtonTappedEmitsChangeMainRoute() {
        let reactor = SignInReactor()
        var receivedRoutes: [SignInReactor.Route] = []

        reactor.route
            .subscribe(onNext: { receivedRoutes.append($0) })
            .disposed(by: disposeBag)

        reactor.mutate(action: .mainbuttonTapped)
            .subscribe()
            .disposed(by: disposeBag)

        XCTAssertEqual(receivedRoutes, [.changeMain])
    }

    func testKakaoButtonTappedEmitsPushSignInDetailRoute() {
        let reactor = SignInReactor()
        var receivedRoutes: [SignInReactor.Route] = []

        reactor.route
            .subscribe(onNext: { receivedRoutes.append($0) })
            .disposed(by: disposeBag)

        reactor.mutate(action: .kakaoButtonTapped)
            .subscribe()
            .disposed(by: disposeBag)

        XCTAssertEqual(receivedRoutes, [.pushSignInDetail])
    }

    func testAppleButtonTappedDoesNotEmitRoute() {
        let reactor = SignInReactor()
        var receivedRoutes: [SignInReactor.Route] = []

        reactor.route
            .subscribe(onNext: { receivedRoutes.append($0) })
            .disposed(by: disposeBag)

        reactor.mutate(action: .appleButtonTapped)
            .subscribe()
            .disposed(by: disposeBag)

        XCTAssertTrue(receivedRoutes.isEmpty)
    }
}

final class SignInDetailViewModelTests: XCTestCase {
    func testBackButtonTappedEmitsPop() {
        let viewModel = SignInDetailViewModel()
        var didEmitPop = false

        viewModel.onOutput = { output in
            if case .onPop = output {
                didEmitPop = true
            }
        }

        viewModel.send(.backButtonTapped)

        XCTAssertTrue(didEmitPop)
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
            response: SignInResponseDTO(isSuccess: true)
        )
        let repository = SignInRepository(networkClient: networkClient)

        let result = try await repository.signIn()

        XCTAssertTrue(result)
        XCTAssertEqual(
            networkClient.receivedEndpoints,
            [
                CoreNetworkEndpoint(
                    path: .signIn,
                    method: .POST,
                    requiresAuthorization: false
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
