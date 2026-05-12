import SwiftUI
import Detail
import DetailTesting

@main
struct DetailDemoApp: App {
    private let useCase: DetailUseCaseProtocol
    private let viewModel: DetailViewModel

    init() {
        self.useCase = MockDetailUseCase.success()
        self.viewModel = DetailViewModel(
            useCase: useCase,
            router: MockDetailRouter()
        )
    }

    var body: some Scene {
        WindowGroup {
            DetailView(viewModel: viewModel)
        }
    }
}
