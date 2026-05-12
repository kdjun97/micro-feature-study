import Combine
import DetailInterface

@MainActor
public final class DetailViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public private(set) var isLoading = false
    @Published public private(set) var logoutMessage = "상태: 노말"
    @Published public var isLogoutFailedAlertPresented = false

    private let useCase: DetailUseCaseProtocol
    private weak var router: DetailRouting?

    public init(
        useCase: DetailUseCaseProtocol,
        router: DetailRouting
    ) {
        self.useCase = useCase
        self.router = router
        self.title = useCase.title()
    }

    public func logoutButtonTapped() async {
        guard !isLoading else { return }

        isLoading = true
        logoutMessage = "상태: 로그아웃 중"
        defer { isLoading = false }

        guard await useCase.logout() else {
            logoutMessage = "상태: 로그아웃 실패"
            isLogoutFailedAlertPresented = true
            return
        }

        logoutMessage = "상태: 노말"
        router?.route(from: .logout)
    }
}
