import DesignSystem
import MyPage
import MyPageTesting
import ReactorKit
import RxSwift
import UIKit

final class MyPageDemoViewController: UIViewController, View {
    var disposeBag = DisposeBag()

    private let mockStore = MyPageMockStore.shared
    private let shakeNavigationController = ShakeNavigationController()
    private lazy var router = MyPageDemoRouter { [weak self] in
        self?.reactor?.action.onNext(.logoutRequested)
    }
    private weak var currentAlert: CustomAlert?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationController()
        reloadMyPage(animated: false)
        reactor = MyPageDemoReactor(mockStore: mockStore)
    }

    func bind(reactor: MyPageDemoReactor) {
        reactor.state
            .map(\.mockState)
            .distinctUntilChanged()
            .skip(1)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.reloadMyPage(animated: false)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.alertCase)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] alertCase in
                self?.renderAlert(alertCase)
            })
            .disposed(by: disposeBag)
    }

    private func setupNavigationController() {
        shakeNavigationController.setNavigationBarHidden(true, animated: false)
        shakeNavigationController.onShake = { [weak self] in
            self?.presentMockSheet()
        }

        addChild(shakeNavigationController)
        shakeNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(shakeNavigationController.view)
        NSLayoutConstraint.activate([
            shakeNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            shakeNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shakeNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shakeNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        shakeNavigationController.didMove(toParent: self)
    }

    private func reloadMyPage(animated: Bool) {
        let builder = MyPageBuilder(
            useCase: MyPageUseCaseStub(
                stateProvider: { [mockStore] in mockStore.state },
                onLogoutFailed: { [weak self] in
                    self?.reactor?.action.onNext(.logoutFailed)
                }
            ),
            makeMyPageReactor: { MyPageReactor(useCase: $0) }
        )
        let viewController = builder.makeMyPageViewController(router: router)
        shakeNavigationController.setViewControllers([viewController], animated: animated)
        shakeNavigationController.becomeFirstResponder()
    }

    private func presentMockSheet() {
        guard
            let topViewController = shakeNavigationController.topViewController,
            topViewController.presentedViewController == nil
        else { return }

        let sheetReactor = MyPageMockSheetReactor(state: mockStore.state)
        let viewController = MyPageMockControlSheetViewController(reactor: sheetReactor) { [weak self] action in
            self?.handleMockAction(action)
        }

        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }

        topViewController.present(viewController, animated: true)
    }

    private func handleMockAction(_ action: MyPageDemoReactor.MockAction) {
        reactor?.action.onNext(.mockActionSelected(action))
    }

    private func renderAlert(_ alertCase: MyPageDemoReactor.AlertCase?) {
        currentAlert?.removeFromSuperview()
        guard let alertCase else { return }

        let customAlert = CustomAlert(
            title: alertCase.title,
            contents: alertCase.contents,
            primaryButtonTitle: alertCase.primaryButtonTitle,
            isDismissable: alertCase.isDismissable
        )
        customAlert.delegate = self
        customAlert.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(customAlert)
        NSLayoutConstraint.activate([
            customAlert.topAnchor.constraint(equalTo: view.topAnchor),
            customAlert.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customAlert.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customAlert.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        currentAlert = customAlert
    }
}

private extension MyPageDemoReactor.AlertCase {
    var title: String {
        switch self {
        case .logoutFailed:
            "로그아웃 실패"
        case .logoutUnavailableInDemo:
            "Demo 앱 안내"
        }
    }

    var contents: String {
        switch self {
        case .logoutFailed:
            "네트워크 상태나 서버 응답에 따라 로그아웃에 실패한 상황입니다."
        case .logoutUnavailableInDemo:
            "Demo 앱에서는 실제 로그아웃을 수행하지 않습니다."
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .logoutFailed, .logoutUnavailableInDemo:
            "확인"
        }
    }

    var isDismissable: Bool {
        switch self {
        case .logoutFailed, .logoutUnavailableInDemo:
            false
        }
    }
}

extension MyPageDemoViewController: CustomAlertDelegate {
    func alertDidTapPrimary(_ alert: CustomAlert) {}
    func alertDidTapSecondary(_ alert: CustomAlert) {}

    func alertDidDismiss(_ alert: CustomAlert) {
        reactor?.action.onNext(.alertDismissed)
    }
}
