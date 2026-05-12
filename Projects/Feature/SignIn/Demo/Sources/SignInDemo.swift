import SwiftUI
import SignIn
import SignInTesting

@main
struct SignInDemoApp: App {
    private let useCase: SignInUseCaseProtocol
    private let viewModel: SignInViewModel
    
    init() {
        self.useCase = MockSignInUseCase.failure()
        self.viewModel = SignInViewModel(
            useCase: useCase,
            router: MockSignInRouter()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView(viewModel: viewModel)
        }
    }
}
