import Combine
import DashboardInterface

@MainActor
public final class DashboardViewModel: ObservableObject {
    @Published public private(set) var title: String

    private let useCase: DashboardUseCase
    private weak var router: DashboardRouting?

    public init(
        useCase: DashboardUseCase,
        router: DashboardRouting
    ) {
        self.useCase = useCase
        self.router = router
        self.title = useCase.title()
    }

    public func backButtonTapped() {
        router?.route(from: .backRequested)
    }
}
