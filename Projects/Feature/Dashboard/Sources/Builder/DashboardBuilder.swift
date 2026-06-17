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
        let viewController = HomeViewController(viewModel: viewModel)

        viewModel.onOutput = { [weak router] output in
            Task { @MainActor [weak router] in
                switch output {
                case .onPushDetail:
                    router?.route(from: .detailRequested)
                case .showAlert(let alertCase):
                    router?.route(from: .alert(alertCase))
                }
            }
        }

        return viewController
    }
}
