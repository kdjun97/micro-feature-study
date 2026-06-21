import UIKit
import DesignSystem

final class ColorShowcaseViewController: ShowcaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Colors"
        navigationItem.largeTitleDisplayMode = .never

        addSection(
            title: "Brand Colors",
            description: "DesignSystem UIColor extension으로 노출된 컬러 토큰입니다.",
            arrangedSubviews: ColorToken.brand.map(makeColorRow)
        )

        addSection(
            title: "Gray Scale",
            arrangedSubviews: ColorToken.grayScale.map(makeColorRow)
        )
    }

    private func makeColorRow(_ token: ColorToken) -> UIView {
        let swatchView = UIView()
        swatchView.backgroundColor = token.color
        swatchView.layer.cornerRadius = 8
        swatchView.layer.borderWidth = 1
        swatchView.layer.borderColor = UIColor.separator.cgColor
        swatchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            swatchView.widthAnchor.constraint(equalToConstant: 44),
            swatchView.heightAnchor.constraint(equalToConstant: 44)
        ])

        let nameLabel = UILabel()
        nameLabel.text = token.name
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = .label

        let hexLabel = UILabel()
        hexLabel.text = token.color.hexString
        hexLabel.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        hexLabel.textColor = .secondaryLabel

        let textStackView = UIStackView(arrangedSubviews: [nameLabel, hexLabel])
        textStackView.axis = .vertical
        textStackView.spacing = 2

        let stackView = UIStackView(arrangedSubviews: [swatchView, textStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }
}

private struct ColorToken {
    let name: String
    let color: UIColor

    static let brand: [ColorToken] = [
        .init(name: ".main", color: .main),
        .init(name: ".sub", color: .sub),
        .init(name: ".medium", color: .medium),
        .init(name: ".bright", color: .bright),
        .init(name: ".buddhism", color: .buddhism),
        .init(name: ".possibility", color: .possibility),
        .init(name: ".uBlack", color: .uBlack)
    ]

    static let grayScale: [ColorToken] = [
        .init(name: ".gray1", color: .gray1),
        .init(name: ".gray2", color: .gray2),
        .init(name: ".gray3", color: .gray3),
        .init(name: ".gray4", color: .gray4),
        .init(name: ".gray5", color: .gray5),
        .init(name: ".gray6", color: .gray6)
    ]
}

private extension UIColor {
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return "#--------"
        }

        return String(
            format: "#%02X%02X%02X · %.0f%%",
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255),
            alpha * 100
        )
    }
}
