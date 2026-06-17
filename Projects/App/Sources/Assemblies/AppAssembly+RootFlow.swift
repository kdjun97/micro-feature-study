import Root
import SignInInterface
import Swinject

extension AppAssembly {
    func assembleRootFlow(in container: Container) {
        container.register(RootCoordinatorBuildable.self) { resolver in
            let signInBuilder: SignInBuildable = resolver.resolve()
            return RootCoordinatorBuilder(signInBuilder: signInBuilder)
        }
    }
}
