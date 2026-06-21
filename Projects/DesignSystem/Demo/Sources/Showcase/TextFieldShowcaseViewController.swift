import UIKit
import DesignSystem

final class TextFieldShowcaseViewController: ShowcaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TextField"
        navigationItem.largeTitleDisplayMode = .never

        addSection(
            title: "CustomTextField",
            description: "패딩과 return-key dismiss가 적용된 UITextField 샘플입니다.",
            arrangedSubviews: TextFieldCase.allCases.map { textFieldCase in
                ShowcaseRows.labeledRow(
                    title: textFieldCase.title,
                    valueView: makeTextField(for: textFieldCase)
                )
            }
        )
    }

    private func makeTextField(for textFieldCase: TextFieldCase) -> UITextField {
        let textField = CustomTextField()
        textField.placeholder = textFieldCase.placeholder
        textField.text = textFieldCase.text
        textField.isSecureTextEntry = textFieldCase.isSecureTextEntry
        textField.keyboardType = textFieldCase.keyboardType
        textField.backgroundColor = .secondarySystemBackground
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = textFieldCase.borderColor.cgColor
        textField.textColor = .label
        textField.tintColor = .main
        textField.setPlaceholder(color: .gray4)
        textField.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return textField
    }
}

private enum TextFieldCase: CaseIterable {
    case placeholder
    case filled
    case secure
    case email
    case error

    var title: String {
        switch self {
        case .placeholder: "Placeholder"
        case .filled: "Filled"
        case .secure: "Secure"
        case .email: "Email Keyboard"
        case .error: "Error"
        }
    }

    var placeholder: String {
        switch self {
        case .placeholder: "이름을 입력해 주세요"
        case .filled: "닉네임"
        case .secure: "비밀번호"
        case .email: "이메일"
        case .error: "필수 입력값입니다"
        }
    }

    var text: String? {
        switch self {
        case .filled: "DesignSystem"
        case .error: ""
        default: nil
        }
    }

    var isSecureTextEntry: Bool {
        switch self {
        case .secure: true
        default: false
        }
    }

    var keyboardType: UIKeyboardType {
        switch self {
        case .email: .emailAddress
        default: .default
        }
    }

    var borderColor: UIColor {
        switch self {
        case .error: .systemRed
        default: .gray2
        }
    }
}
