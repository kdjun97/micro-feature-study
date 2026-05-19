@MainActor
public protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidRequestLogout(_ coordinator: MainCoordinator)
}
