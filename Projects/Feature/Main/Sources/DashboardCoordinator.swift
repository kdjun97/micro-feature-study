import Base
import DashboardInterface
import DetailInterface
import UIKit

@MainActor
public protocol DashboardCoordinatorDelegate: AnyObject {
    func dashboardCoordinatorDidRequestLogout(_ coordinator: DashboardCoordinator)
    func dashboardCoordinator(_ coordinator: DashboardCoordinator, didRequestAlert event: DashboardAlertEvent)
}

public final class DashboardCoordinator {
    public let navigationController: UINavigationController
    public weak var delegate: DashboardCoordinatorDelegate?

    private let dashboardBuilder: DashboardBuildable
    private let detailBuilder: DetailBuildable

    public init(
        navigationController: UINavigationController = SwipeBackNavigationController(),
        dashboardBuilder: DashboardBuildable,
        detailBuilder: DetailBuildable,
        delegate: DashboardCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        self.dashboardBuilder = dashboardBuilder
        self.detailBuilder = detailBuilder
        self.delegate = delegate
        navigationController.setNavigationBarHidden(true, animated: false)
        print("⭕ DashboardCoordinator init!")
    }

    deinit {
        print("❎ DashboardCoordinator deinit!")
    }

    @MainActor
    public func start() {
        let viewController = dashboardBuilder.makeDashboardViewController(router: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension DashboardCoordinator: DashboardRouting {
    public func route(from route: DashboardRoute) {
        switch route {
        case .detailRequested:
            showDetail()
        case .alertRequested(let event):
            delegate?.dashboardCoordinator(self, didRequestAlert: event)
        }
    }
}

extension DashboardCoordinator {
    @MainActor
    func makeAlertView(for event: DashboardAlertEvent) -> UIView {
        dashboardBuilder.makeDashboardAlertView(for: event)
    }
}

extension DashboardCoordinator: DetailRouting {
    public func route(from route: DetailRoute) {
        switch route {
        case .sheet:
            presentDetailSheet()
        case .logout:
            delegate?.dashboardCoordinatorDidRequestLogout(self)
        }
    }
}

private extension DashboardCoordinator {
    @MainActor
    func showDetail() {
        let viewController = detailBuilder.makeDetailViewController(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    @MainActor
    func presentDetailSheet() {
        let viewController = detailBuilder.makeDetailSheetViewController()
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(viewController, animated: true)
    }
}
