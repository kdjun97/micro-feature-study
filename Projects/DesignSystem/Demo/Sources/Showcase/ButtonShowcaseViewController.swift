import UIKit
import SwiftUI
import DesignSystem

final class ButtonShowcaseViewController: ShowcaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Button"
        navigationItem.largeTitleDisplayMode = .never

        addSection(
            title: "UIKit / SwiftUI",
            description: "같은 variant와 size 토큰으로 만든 버튼을 플랫폼별 구현으로 비교합니다.",
            arrangedSubviews: ButtonCase.allCases.map { buttonCase in
                ShowcaseRows.labeledRow(
                    title: buttonCase.title,
                    valueView: makeComparisonRow(for: buttonCase)
                )
            }
        )
    }

    private func makeButton(for buttonCase: ButtonCase) -> UIButton {
        let button = CustomButton(
            title: buttonCase.buttonTitle,
            variant: buttonCase.variant,
            size: buttonCase.size
        )
        button.isEnabled = buttonCase.isEnabled
        return button
    }

    private func makeComparisonRow(for buttonCase: ButtonCase) -> UIView {
        let stackView = UIStackView(arrangedSubviews: [
            makePlatformColumn(title: "UIKit", valueView: makeButton(for: buttonCase)),
            makePlatformColumn(title: "SwiftUI", valueView: makeSwiftUIButton(for: buttonCase))
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }

    private func makePlatformColumn(title: String, valueView: UIView) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textColor = .secondaryLabel

        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueView])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }

    private func makeSwiftUIButton(for buttonCase: ButtonCase) -> UIView {
        let containerView = UIView()
        let hostingController = UIHostingController(
            rootView: CustomSwiftUIButton(
                title: buttonCase.buttonTitle,
                variant: buttonCase.variant,
                size: buttonCase.size,
                isEnabled: buttonCase.isEnabled,
                action: {}
            )
        )
        addChild(hostingController)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        return containerView
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

    var variant: DesignSystemButtonVariant {
        switch self {
        case .primary: .primary
        case .secondary: .secondary
        case .destructive: .destructive
        case .disabled: .primary
        }
    }

    var size: DesignSystemButtonSize {
        switch self {
        case .secondary: .medium
        case .primary, .destructive, .disabled: .large
        }
    }

    var isEnabled: Bool {
        switch self {
        case .disabled: false
        default: true
        }
    }
}
