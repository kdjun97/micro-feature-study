import DashboardInterface
import SwiftUI

public struct DashboardBuilder: DashboardBuildable {
    private let useCase: DashboardUseCaseProtocol

    public init(useCase: DashboardUseCaseProtocol) {
        self.useCase = useCase
    }

    @MainActor
    public func makeDashboardView(router: DashboardRouting) -> AnyView {
        let viewModel = DashboardViewModel(
            useCase: useCase,
            router: router
        )
        return AnyView(DashboardView(viewModel: viewModel))
    }
}
