import CoreAuthInterface
import SignInInterface
import SwiftUI

public struct SignInBuilder: SignInBuildable {
    private let useCase: SignInUseCaseProtocol
    private let coreAuthUseCase: CoreAuthInterface

    public init(
        useCase: SignInUseCaseProtocol,
        coreAuthUseCase: CoreAuthInterface
    ) {
        self.useCase = useCase
        self.coreAuthUseCase = coreAuthUseCase
    }

    @MainActor
    public func makeSignInView(router: SignInRouting) -> AnyView {
        let viewModel = SignInViewModel(
            useCase: useCase,
            coreAuthUseCase: coreAuthUseCase,
            router: router
        )

        return AnyView(SignInView(viewModel: viewModel))
    }
}
