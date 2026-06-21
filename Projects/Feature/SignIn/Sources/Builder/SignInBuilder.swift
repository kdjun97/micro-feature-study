import CoreAuthInterface
import SignInInterface
import UIKit

public struct SignInBuilder: SignInBuildable {
    private let useCase: SignInUseCaseProtocol
    private let coreAuthUseCase: CoreAuthInterface
    private let makeSignInReactor: () -> SignInReactor
    private let makeSignInDetailViewModel: () -> SignInDetailViewModel

    public init(
        useCase: SignInUseCaseProtocol,
        coreAuthUseCase: CoreAuthInterface,
        makeSignInReactor: @escaping () -> SignInReactor,
        makeSignInDetailViewModel: @escaping () -> SignInDetailViewModel
    ) {
        self.useCase = useCase
        self.coreAuthUseCase = coreAuthUseCase
        self.makeSignInReactor = makeSignInReactor
        self.makeSignInDetailViewModel = makeSignInDetailViewModel
    }

    @MainActor
    public func makeSignInViewController(router: SignInRouting) -> UIViewController {
        let reactor = makeSignInReactor()
        let viewController = SignInViewController(reactor: reactor)

        reactor.route
            .subscribe(onNext: { [weak router] route in
                Task { @MainActor [weak router] in
                    switch route {
                    case .changeMain:
                        router?.route(from: .signInSucceeded)
                    case .pushSignInDetail:
                        router?.route(from: .signInDetailRequested)
                    }
                }
            })
            .disposed(by: viewController.disposeBag)

        return viewController
    }

    @MainActor
    public func makeSignInDetailViewController(router: SignInRouting) -> UIViewController {
        let viewModel = makeSignInDetailViewModel()
        let viewController = SignInDetailViewController(viewModel: viewModel)

        viewModel.onOutput = { [weak router] output in
            Task { @MainActor [weak router] in
                switch output {
                case .onPop:
                    router?.route(from: .signInDetailBackRequested)
                }
            }
        }

        return viewController
    }
}
