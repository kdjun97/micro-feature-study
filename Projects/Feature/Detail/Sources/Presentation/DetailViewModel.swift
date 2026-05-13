import Combine
import CoreAuthInterface
import DetailInterface

@MainActor
public final class DetailViewModel: ObservableObject {
    @Published public private(set) var title: String
    @Published public private(set) var isLoading = false
    @Published public private(set) var logoutMessage = "상태: 노말"
    @Published public private(set) var userProfileMessage = "유저: 없음"
    @Published public var isLogoutFailedAlertPresented = false

    private let useCase: DetailUseCaseProtocol
    private let coreAuthUseCase: CoreAuthInterface
    private weak var router: DetailRouting?

    public init(
        useCase: DetailUseCaseProtocol,
        coreAuthUseCase: CoreAuthInterface,
        router: DetailRouting
    ) {
        self.useCase = useCase
        self.coreAuthUseCase = coreAuthUseCase
        self.router = router
        self.title = useCase.title()
    }

    public func logoutButtonTapped() async {
        guard !isLoading else { return }

        isLoading = true
        logoutMessage = "상태: 로그아웃 중"
        defer { isLoading = false }

        do {
            let userProfile = try await coreAuthUseCase.getUserProfile()
            userProfileMessage = "유저: \(userProfile.name)"
        } catch {
            logoutMessage = "상태: 유저 정보 실패"
            isLogoutFailedAlertPresented = true
            return
        }

        guard await useCase.logout() else {
            logoutMessage = "상태: 로그아웃 실패"
            isLogoutFailedAlertPresented = true
            return
        }

        logoutMessage = "상태: 노말"
        router?.route(from: .logout)
    }
}
