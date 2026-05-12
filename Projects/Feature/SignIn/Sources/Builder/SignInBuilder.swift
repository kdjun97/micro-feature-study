import SignInInterface
import SwiftUI

public struct SignInBuilder: SignInBuildable {
    private let useCase: SignInUseCaseProtocol

    public init(useCase: SignInUseCaseProtocol) {
        self.useCase = useCase
    }

    @MainActor
    public func makeSignInView(router: SignInRouting) -> AnyView {
        let viewModel = SignInViewModel(
            useCase: useCase,
            router: router
        )

        return AnyView(SignInView(viewModel: viewModel))
    }
}
