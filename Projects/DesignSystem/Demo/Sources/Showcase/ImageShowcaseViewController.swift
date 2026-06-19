import UIKit
import DesignSystem

final class ImageShowcaseViewController: ShowcaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Images"
        navigationItem.largeTitleDisplayMode = .never

        addSection(
            title: "Icons",
            description: "DesignSystem UIImage extension으로 노출된 이미지 에셋입니다.",
            arrangedSubviews: ImageToken.allCases.map(makeImageRow)
        )
    }

    private func makeImageRow(_ token: ImageToken) -> UIView {
        let imageContainerView = UIView()
        imageContainerView.backgroundColor = .tertiarySystemGroupedBackground
        imageContainerView.layer.cornerRadius = 12
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView(image: token.image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .main
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageContainerView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageContainerView.widthAnchor.constraint(equalToConstant: 56),
            imageContainerView.heightAnchor.constraint(equalToConstant: 56),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 36),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 36)
        ])

        let nameLabel = UILabel()
        nameLabel.text = token.title
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = .label

        let stackView = UIStackView(arrangedSubviews: [imageContainerView, nameLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        return stackView
    }
}

private enum ImageToken: CaseIterable {
    case character
    case apple
    case kakao
    case arrowLeft
    case arrowRight

    var title: String {
        switch self {
        case .character: ".icCharacter"
        case .apple: ".icApple"
        case .kakao: ".icKakao"
        case .arrowLeft: ".icArrowLeft"
        case .arrowRight: ".icArrowRight"
        }
    }

    var image: UIImage {
        switch self {
        case .character: .icCharacter
        case .apple: .icApple
        case .kakao: .icKakao
        case .arrowLeft: .icArrowLeft
        case .arrowRight: .icArrowRight
        }
    }
}
