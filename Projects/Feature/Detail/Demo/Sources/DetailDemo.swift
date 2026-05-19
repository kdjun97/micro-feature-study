import SwiftUI
import CoreAuthTesting
import Detail
import DetailTesting
import DetailInterface

@main
struct DetailDemoApp: App {
    private let useCase: DetailUseCaseProtocol
    private let coreAuthUseCase: MockCoreAuthUseCase
    private let viewModel: DetailViewModel

    init() {
        self.useCase = MockDetailUseCase.failure()
        self.coreAuthUseCase = MockCoreAuthUseCase.success()
        self.viewModel = DetailViewModel(
            useCase: useCase,
            coreAuthUseCase: coreAuthUseCase,
            router: MockDetailRouter()
        )
    }

    var body: some Scene {
        WindowGroup {
            DetailView(viewModel: viewModel)
        }
    }
}
