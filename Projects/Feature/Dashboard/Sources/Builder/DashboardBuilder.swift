import DashboardInterface
import UIKit

public struct DashboardBuilder: DashboardBuildable {
    private let useCase: DashboardUseCaseProtocol
    private let makeHomeViewModel: () -> HomeViewModel

    public init(
        useCase: DashboardUseCaseProtocol,
        makeHomeViewModel: @escaping () -> HomeViewModel
    ) {
        self.useCase = useCase
        self.makeHomeViewModel = makeHomeViewModel
    }

    @MainActor
    public func makeDashboardViewController(router: DashboardRouting) -> UIViewController {
        let viewModel = makeHomeViewModel()

        viewModel.onRoute = { [weak router] route in
            Task { @MainActor [weak router] in
                switch route {
                case .detailRequested:
                    router?.route(from: .detailRequested)
                }
            }
        }

        return HomeViewController(viewModel: viewModel)
    }
}
