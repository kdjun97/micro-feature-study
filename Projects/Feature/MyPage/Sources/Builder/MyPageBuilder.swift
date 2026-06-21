import MyPageInterface
import RxSwift
import UIKit

public struct MyPageBuilder: MyPageBuildable {
    private let useCase: MyPageUseCaseProtocol
    private let makeMyPageReactor: (MyPageUseCaseProtocol) -> MyPageReactor

    public init(
        useCase: MyPageUseCaseProtocol,
        makeMyPageReactor: @escaping (MyPageUseCaseProtocol) -> MyPageReactor
    ) {
        self.useCase = useCase
        self.makeMyPageReactor = makeMyPageReactor
    }

    @MainActor
    public func makeMyPageViewController(router: MyPageRouting) -> UIViewController {
        let reactor = makeMyPageReactor(useCase)
        let viewController = MyPageViewController(reactor: reactor)

        reactor.route
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak router] route in
                switch route {
                case .logout:
                    router?.route(from: .logoutRequested)
                }
            })
            .disposed(by: viewController.disposeBag)

        return viewController
    }
}
