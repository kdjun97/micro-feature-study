import Root
import SignInInterface
import Swinject

extension AppAssembly {
    func assembleRootFlow(in container: Container) {
        container.register(RootCoordinator.self) { (resolver: Resolver, delegate: RootCoordinatorDelegate) in
            let signInBuilder: SignInBuildable = resolver.resolve()
            return RootCoordinator(
                signInBuilder: signInBuilder,
                delegate: delegate
            )
        }
    }
}
