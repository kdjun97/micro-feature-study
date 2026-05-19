import SwiftUI
import CoreAuthTesting
import SignIn
import SignInTesting
import SignInInterface

@main
struct SignInDemoApp: App {
    private let useCase: SignInUseCaseProtocol
    private let coreAuthUseCase: MockCoreAuthUseCase
    private let viewModel: SignInViewModel
    
    init() {
        self.useCase = MockSignInUseCase.failure()
        self.coreAuthUseCase = MockCoreAuthUseCase.success()
        self.viewModel = SignInViewModel(
            useCase: useCase,
            coreAuthUseCase: coreAuthUseCase,
            router: MockSignInRouter()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView(viewModel: viewModel)
        }
    }
}
