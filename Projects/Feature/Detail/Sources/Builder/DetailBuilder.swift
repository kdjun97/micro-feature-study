import DetailInterface
import SwiftUI

public struct DetailBuilder: DetailBuildable {
    private let useCase: DetailUseCaseProtocol

    public init(useCase: DetailUseCaseProtocol) {
        self.useCase = useCase
    }

    public func makeDetailView(router: any DetailRouting) -> AnyView {
        let viewModel = DetailViewModel(
            useCase: useCase,
            router: router
        )

        return AnyView(DetailView(viewModel: viewModel))
    }
}
