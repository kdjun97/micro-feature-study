import SwiftUI
import Detail
import DetailTesting
import DetailInterface

@main
struct DetailDemoApp: App {
    private let useCase: DetailUseCaseProtocol
    private let viewModel: DetailViewModel

    init() {
        self.useCase = MockDetailUseCase.failure()
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
