import Combine
import CoreAuthInterface
import SignInInterface

@MainActor
public final class SignInViewModel: ObservableObject {
    @Published public private(set) var isLoading = false
    @Published public private(set) var errorMessage = "상태: 노말"
    @Published public private(set) var userProfileMessage = "유저: 없음"

    private let useCase: any SignInUseCaseProtocol
    private let coreAuthUseCase: CoreAuthInterface
    private weak var router: SignInRouting?

    public init(
        useCase: any SignInUseCaseProtocol,
        coreAuthUseCase: CoreAuthInterface,
        router:  SignInRouting
    ) {
        self.useCase = useCase
        self.coreAuthUseCase = coreAuthUseCase
        self.router = router
    }

    public func signInButtonTapped() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = "상태: 로딩"
        defer { isLoading = false }

        guard await useCase.signIn() else {
            errorMessage = "상태: 로그인 실패"
            return
        }

        do {
            let userProfile = try await coreAuthUseCase.getUserProfile()
            userProfileMessage = "유저: \(userProfile.name)"
            errorMessage = "상태: 노말"
        } catch {
            errorMessage = "상태: 유저 정보 실패"
            return
        }

        router?.route(from: .signInSucceeded)
    }

    public func dashboardButtonTapped() {
        router?.route(from: .dashboardRequested)
    }
}
