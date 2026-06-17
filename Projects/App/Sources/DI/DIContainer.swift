import UIKit
import Swinject

final class AppDIContainer {
    private let assembler: Assembler

    init() {
        assembler = Assembler([
            AppAssembly()
        ])
    }

    func makeAppCoordinator(window: UIWindow) -> AppCoordinator {
        assembler.resolver.resolve(argument: window)
    }
}


extension Resolver {
    func resolve<T>() -> T {
        guard let instance = resolve(T.self) else {
            fatalError("DI Error: cannot resolve \(String(describing: T.self))")
        }
        return instance
    }

    func resolve<T, Argument>(argument: Argument) -> T {
        guard let instance = resolve(T.self, argument: argument) else {
            fatalError("DI Error: cannot resolve \(String(describing: T.self)) with argument \(String(describing: Argument.self))")
        }
        return instance
    }
}
