import CoreAuthInterface
import DetailInterface
import UIKit

public struct DetailBuilder: DetailBuildable {
    private let useCase: DetailUseCaseProtocol
    private let coreAuthUseCase: CoreAuthInterface
    private let makeDetailViewModel: () -> DetailViewModel

    public init(
        useCase: DetailUseCaseProtocol,
        coreAuthUseCase: CoreAuthInterface,
        makeDetailViewModel: @escaping () -> DetailViewModel
    ) {
        self.useCase = useCase
        self.coreAuthUseCase = coreAuthUseCase
        self.makeDetailViewModel = makeDetailViewModel
    }

    @MainActor
    public func makeDetailViewController(router: DetailRouting) -> UIViewController {
        let viewModel = makeDetailViewModel()
        let viewController = DetailViewController(viewModel: viewModel)

        viewModel.onOutput = { [weak router] output in
            Task { @MainActor [weak router] in
                switch output {
                case .onPresentSheet:
                    router?.route(from: .sheet)
                }
            }
        }

        return viewController
    }

    @MainActor
    public func makeDetailSheetViewController() -> UIViewController {
        DetailSheetViewController()
    }
}
