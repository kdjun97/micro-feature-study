import DashboardInterface
import DetailInterface
import UIKit
import DesignSystem
import SnapKit

public final class MainCoordinator {
    public let navigationController: UINavigationController
    public weak var delegate: MainCoordinatorDelegate?

    private let dashboardBuilder: DashboardBuildable
    private let detailBuilder: DetailBuildable
    private weak var currentAlert: CustomAlert?

    public init(
        navigationController: UINavigationController = UINavigationController(),
        dashboardBuilder: DashboardBuildable,
        detailBuilder: DetailBuildable,
        delegate: MainCoordinatorDelegate? = nil
    ) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: false)
        self.dashboardBuilder = dashboardBuilder
        self.detailBuilder = detailBuilder
        self.delegate = delegate
    }

    @MainActor
    public func start() {
        showDashboard()
    }

    @MainActor
    private func showDashboard() {
        let viewController = dashboardBuilder.makeDashboardViewController(router: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    @MainActor
    private func showDetail() {
        let viewController = detailBuilder.makeDetailViewController(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    @MainActor
    private func presentDetailSheet() {
        let viewController = detailBuilder.makeDetailSheetViewController()
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        navigationController.present(viewController, animated: true)
    }

    @MainActor
    private func renderAlert(_ alertCase: HomeAlertCase?) {
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

extension MainCoordinator: DashboardRouting {
    public func route(from route: DashboardRoute) {
        switch route {
        case .detailRequested:
            showDetail()
        case .alert(let alertCase):
            renderAlert(alertCase)
        }
    }
}

extension MainCoordinator: DetailRouting {
    public func route(from route: DetailRoute) {
        switch route {
        case .sheet:
            presentDetailSheet()
        case .logout:
            delegate?.mainCoordinatorDidRequestLogout(self)
        }
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
