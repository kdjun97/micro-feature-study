import UIKit

struct ShowcaseRows {
    static func labeledRow(title: String, valueView: UIView) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.setContentHuggingPriority(.required, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [label, valueView])
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }

    static func horizontalRow(title: String, valueView: UIView) -> UIView {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.setContentHuggingPriority(.required, for: .horizontal)

        let stackView = UIStackView(arrangedSubviews: [label, UIView(), valueView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }
}
