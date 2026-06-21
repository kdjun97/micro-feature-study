import UIKit
import DesignSystem

final class AlertShowcaseViewController: ShowcaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Alert"
        navigationItem.largeTitleDisplayMode = .never

        addSection(
            title: "CustomAlert",
            description: "CustomAlert를 화면 최상위 view에 overlay로 붙여 확인합니다.",
            arrangedSubviews: AlertCase.allCases.map { alertCase in
                ShowcaseRows.labeledRow(
                    title: alertCase.title,
                    valueView: makeTriggerButton(for: alertCase)
                )
            }
        )
    }

    private func makeTriggerButton(for alertCase: AlertCase) -> UIButton {
        let button = CustomButton(
            title: alertCase.buttonTitle,
            backgroundColor: .main,
            foregroundColor: .white,
            edgeInsets: NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        )
        button.addAction(UIAction { [weak self] _ in
            self?.presentAlert(for: alertCase)
        }, for: .touchUpInside)
        return button
    }

    private func presentAlert(for alertCase: AlertCase) {
        guard let containerView = navigationController?.view ?? self.view else { return }
        let alert = CustomAlert(
            title: alertCase.alertTitle,
            contents: alertCase.contents,
            primaryButtonTitle: alertCase.primaryButtonTitle,
            secondaryButtonTitle: alertCase.secondaryButtonTitle,
            isDismissable: alertCase.isDismissable
        )
        alert.delegate = self
        alert.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(alert)
        NSLayoutConstraint.activate([
            alert.topAnchor.constraint(equalTo: containerView.topAnchor),
            alert.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            alert.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            alert.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}

extension AlertShowcaseViewController: CustomAlertDelegate {
    func alertDidTapPrimary(_ alert: CustomAlert) {}
    func alertDidTapSecondary(_ alert: CustomAlert) {}
    func alertDidDismiss(_ alert: CustomAlert) {}
}

private enum AlertCase: CaseIterable {
    case singleAction
    case doubleAction
    case dismissable

    var title: String {
        switch self {
        case .singleAction: "Single Action"
        case .doubleAction: "Double Action"
        case .dismissable: "Background Dismiss"
        }
    }

    var buttonTitle: String {
        switch self {
        case .singleAction: "단일 버튼 Alert 보기"
        case .doubleAction: "이중 버튼 Alert 보기"
        case .dismissable: "Dimmed 영역 닫기 Alert 보기"
        }
    }

    var alertTitle: String {
        switch self {
        case .singleAction: "알림"
        case .doubleAction: "삭제할까요?"
        case .dismissable: "배경 탭 가능"
        }
    }

    var contents: String {
        switch self {
        case .singleAction: "확인 버튼 하나만 있는 기본 Alert입니다."
        case .doubleAction: "취소와 확인 버튼이 함께 있는 Alert입니다."
        case .dismissable: "Dimmed 영역을 탭하면 Alert가 닫힙니다."
        }
    }

    var primaryButtonTitle: String {
        switch self {
        case .singleAction, .dismissable: "확인"
        case .doubleAction: "취소"
        }
    }

    var secondaryButtonTitle: String? {
        switch self {
        case .doubleAction: "삭제"
        default: nil
        }
    }

    var isDismissable: Bool {
        switch self {
        case .dismissable: true
        default: false
        }
    }
}
