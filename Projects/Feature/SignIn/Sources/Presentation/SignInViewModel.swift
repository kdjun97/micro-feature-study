import Combine
import SignInInterface

@MainActor
public final class SignInViewModel: ObservableObject {
    @Published public private(set) var isLoading = false
    @Published public private(set) var errorMessage = "상태: 노말"

    private let useCase: any SignInUseCaseProtocol
    private weak var router: SignInRouting?

    public init(
        useCase: any SignInUseCaseProtocol,
        router:  SignInRouting
    ) {
        self.useCase = useCase
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

        errorMessage = "상태: 노말"
        router?.route(from: .signInSucceeded)
    }

    public func dashboardButtonTapped() {
        router?.route(from: .dashboardRequested)
    }
}
