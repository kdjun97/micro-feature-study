import Base
import DashboardInterface
import DesignSystem
import DetailInterface
import SnapKit
import UIKit

@MainActor
public protocol DashboardCoordinatorDelegate: AnyObject {
    func dashboardCoordinatorDidRequestLogout(_ coordinator: DashboardCoordinator)
}

public final class DashboardCoordinator {
    public let navigationController: UINavigationController
    public weak var delegate: DashboardCoordinatorDelegate?

    private let dashboardBuilder: DashboardBuildable
    private let detailBuilder: DetailBuildable
    private weak var currentAlert: CustomAlert?

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
        case .alert(let alertCase):
            renderAlert(alertCase)
        }
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

    @MainActor
    func renderAlert(_ alertCase: HomeAlertCase?) {
        currentAlert?.removeFromSuperview()
        guard let alertCase else { return }
        let alert = CustomAlert(
            title: alertCase.title,
            contents: alertCase.contents,
            primaryButtonTitle: alertCase.primaryButtonTitle,
            secondaryButtonTitle: alertCase.secondaryButtonTitle,
            isDismissable: alertCase.isDismissable
        )
        navigationController.view.addSubview(alert)
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        currentAlert = alert
    }
}

private extension HomeAlertCase {
    var title: String {
        switch self {
        case .tip:
            "[꿀팁] 테스트 꿀팁!"
        case .stopEditing:
            "편집을 중단할까요?"
        }
    }

    var contents: String {
        switch self {
        case .tip:
            "어떤게 꿀팁이 될 수 있을지 잘 모르겠지만 일단은 적어봄."
        case .stopEditing:
            "편집을 중단하시면 지금까지 수정한 내용이 모두 삭제됩니다."
        }
    }

    var primaryButtonTitle: String {
        "닫기"
    }

    var secondaryButtonTitle: String? {
        switch self {
        case .tip:
            nil
        case .stopEditing:
            "확인"
        }
    }

    var isDismissable: Bool {
        switch self {
        case .tip:
            true
        case .stopEditing:
            false
        }
    }
}
