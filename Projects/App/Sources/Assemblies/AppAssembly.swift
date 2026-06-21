import Swinject

struct AppAssembly: Assembly {
    func assemble(container: Container) {
        assembleCore(in: container)
        assembleFeatures(in: container)
        assembleRootFlow(in: container)
        assembleMainFlow(in: container)
        assembleApp(in: container)
    }
}
