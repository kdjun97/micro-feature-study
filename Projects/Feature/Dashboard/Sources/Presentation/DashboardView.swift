import UIKit
import DesignSystem
import SnapKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("⭕ HomeViewController init!")
    }

    deinit {
        print("❎ HomeViewController deinit!")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private let navigationBar: UILabel = {
        let label = UILabel()
        label.text = "홈"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let heroCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .bright
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "나는빡빡이다"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        return label
    }()

    private let heroDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "시미가 준비한 홈에서 기록 흐름과 안내 메시지를 자연스럽게 검증할 수 있어요."
        label.textColor = .gray6
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .icCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 해볼 수 있는 것"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let detailButton = HomeActionButton(
        title: "오늘의 기록 살펴보기",
        subtitle: "상세 화면으로 이동해 기록 흐름을 확인해요",
        backgroundColor: .main,
        accentColor: .white.withAlphaComponent(0.8),
        titleColor: .white,
        subtitleColor: .white.withAlphaComponent(0.85),
        arrowTintColor: .white
    )

    private let tipAlertButton = HomeActionButton(
        title: "시미의 도움말 보기",
        subtitle: "검증 중 필요한 팁 안내를 띄워볼 수 있어요",
        accentColor: .sub
    )

    private let stopEditingAlertButton = HomeActionButton(
        title: "작성 중단 안내 확인",
        subtitle: "편집을 멈출 때의 확인 메시지를 확인해요",
        accentColor: .gray6
    )

    private let footerLabel: UILabel = {
        let label = UILabel()
        label.text = "기능 검증용 화면이에요. 실제 데이터 없이 화면 흐름만 확인합니다."
        label.textColor = .gray5
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        setAction()
    }

    private func setupLayout() {
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide).inset(24)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(20)
            $0.width.equalTo(scrollView.frameLayoutGuide).offset(-40)
        }

        setupHeroCardLayout()
        setupActionLayout()
    }

    private func setupHeroCardLayout() {
        heroCardView.addSubview(greetingLabel)
        heroCardView.addSubview(heroDescriptionLabel)
        heroCardView.addSubview(characterImageView)
        contentStackView.addArrangedSubview(heroCardView)

        heroCardView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(184)
        }

        greetingLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
            $0.trailing.lessThanOrEqualTo(characterImageView.snp.leading).offset(-12)
        }

        heroDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(12)
            $0.leading.equalTo(greetingLabel)
            $0.trailing.lessThanOrEqualTo(characterImageView.snp.leading).offset(-12)
            $0.bottom.lessThanOrEqualToSuperview().inset(24)
        }

        characterImageView.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
            $0.width.height.equalTo(104)
        }
    }

    private func setupActionLayout() {
        contentStackView.addArrangedSubview(sectionTitleLabel)
        contentStackView.setCustomSpacing(12, after: sectionTitleLabel)
        contentStackView.addArrangedSubview(detailButton)
        contentStackView.addArrangedSubview(tipAlertButton)
        contentStackView.addArrangedSubview(stopEditingAlertButton)
        contentStackView.addArrangedSubview(footerLabel)
        contentStackView.setCustomSpacing(28, after: stopEditingAlertButton)

        [detailButton, tipAlertButton, stopEditingAlertButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(78)
            }
        }
    }
}

private extension HomeViewController {
    func setAction() {
        detailButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        tipAlertButton.addTarget(self, action: #selector(tipAlertButtonTapped), for: .touchUpInside)
        stopEditingAlertButton.addTarget(self, action: #selector(stopEditingAlertButtonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        viewModel.send(.buttonTapped)
    }

    @objc func tipAlertButtonTapped() {
        viewModel.send(.alertButtonTapped(.tip))
    }

    @objc func stopEditingAlertButtonTapped() {
        viewModel.send(.alertButtonTapped(.stopEditing))
    }
}

private final class HomeActionButton: UIControl {
    private let accentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray6
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .icArrowRight
            .resized(to: CGSize(width: 18, height: 18))
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray6
        return imageView
    }()

    init(
        title: String,
        subtitle: String,
        backgroundColor: UIColor = .gray1,
        accentColor: UIColor,
        titleColor: UIColor = .uBlack,
        subtitleColor: UIColor = .gray6,
        arrowTintColor: UIColor = .gray6
    ) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        titleLabel.text = title
        titleLabel.textColor = titleColor
        subtitleLabel.text = subtitle
        subtitleLabel.textColor = subtitleColor
        accentView.backgroundColor = accentColor
        arrowImageView.tintColor = arrowTintColor
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.16) {
                self.alpha = self.isHighlighted ? 0.65 : 1.0
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.98, y: 0.98)
                    : .identity
            }
        }
    }

    private func setupUI() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
    }

    private func setupLayout() {
        addSubview(accentView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(arrowImageView)

        accentView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(6)
            $0.height.equalTo(34)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(accentView.snp.trailing).offset(14)
            $0.trailing.lessThanOrEqualTo(arrowImageView.snp.leading).offset(-12)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(arrowImageView.snp.leading).offset(-12)
            $0.bottom.equalToSuperview().inset(16)
        }

        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(18)
            $0.width.height.equalTo(18)
        }
    }
}
