import CoreAuthInterface
import DetailInterface
import SwiftUI

public struct DetailBuilder: DetailBuildable {
    private let useCase: DetailUseCaseProtocol
    private let coreAuthUseCase: CoreAuthInterface

    public init(
        useCase: DetailUseCaseProtocol,
        coreAuthUseCase: CoreAuthInterface
    ) {
        self.useCase = useCase
        self.coreAuthUseCase = coreAuthUseCase
    }

    public func makeDetailView(router: any DetailRouting) -> AnyView {
        let viewModel = DetailViewModel(
            useCase: useCase,
            coreAuthUseCase: coreAuthUseCase,
            router: router
        )

        return AnyView(DetailView(viewModel: viewModel))
    }
}
