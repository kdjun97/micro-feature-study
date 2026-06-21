import UIKit
import DesignSystem

final class ButtonShowcaseViewController: ShowcaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Button"
        navigationItem.largeTitleDisplayMode = .never

        addSection(
            title: "CustomButton",
            description: "UIButton.Configuration 기반 DesignSystem 버튼 샘플입니다.",
            arrangedSubviews: ButtonCase.allCases.map { buttonCase in
                ShowcaseRows.labeledRow(
                    title: buttonCase.title,
                    valueView: makeButton(for: buttonCase)
                )
            }
        )
    }

    private func makeButton(for buttonCase: ButtonCase) -> UIButton {
        let button = CustomButton(
            title: buttonCase.buttonTitle,
            backgroundColor: buttonCase.backgroundColor,
            foregroundColor: buttonCase.foregroundColor,
            edgeInsets: NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        )
        button.isEnabled = buttonCase.isEnabled
        button.alpha = buttonCase.isEnabled ? 1 : 0.45
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }
}

private enum ButtonCase: CaseIterable {
    case primary
    case secondary
    case destructive
    case disabled

    var title: String {
        switch self {
        case .primary: "Primary"
        case .secondary: "Secondary"
        case .destructive: "Destructive"
        case .disabled: "Disabled"
        }
    }

    var buttonTitle: String {
        switch self {
        case .primary: "확인"
        case .secondary: "다음에 할게요"
        case .destructive: "삭제"
        case .disabled: "비활성화"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .primary: .main
        case .secondary: .gray1
        case .destructive: .systemRed
        case .disabled: .gray2
        }
    }

    var foregroundColor: UIColor {
        switch self {
        case .primary, .destructive: .white
        case .secondary, .disabled: .uBlack
        }
    }

    var isEnabled: Bool {
        switch self {
        case .disabled: false
        default: true
        }
    }
}
