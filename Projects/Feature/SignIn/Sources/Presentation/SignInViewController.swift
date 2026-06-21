import UIKit
import DesignSystem
import SnapKit
import ReactorKit
import RxCocoa

class SignInViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    deinit {
        print("❎ SignInViewController deinit!")
    }
    
    init(reactor: SignInReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
        print("⭕ SignInViewController init!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .icCharacter
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "환영합니다"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "간편하게 로그인하고 서비스를 시작해보세요."
        label.textColor = .gray6
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    private let button: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .main
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)
        
        var title = AttributedString("둘러보기 시작하기")
        title.font = .systemFont(ofSize: 16, weight: .bold)
        config.attributedTitle = title
        
        return UIButton(configuration: config)
    }()
    
    private let signInOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "또는 소셜 계정으로 로그인"
        label.textColor = .gray5
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textAlignment = .center
        
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        
        return stackView
    }()
    
    private let kakaoButton: UIButton = SignInViewController.makeSignInButton(
        title: "Kakao로 계속하기",
        image: .icKakao,
        backgroundColor: UIColor(red: 1.0, green: 0.91, blue: 0.20, alpha: 1.0),
        foregroundColor: .uBlack
    )
    
    private let appleButton: UIButton = SignInViewController.makeSignInButton(
        title: "Apple로 계속하기",
        image: .icApple,
        backgroundColor: .uBlack,
        foregroundColor: .white
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLayout()
    }
    
    private func setupLayout() {
        setupContentLayout()
        setupButtonLayout()
    }
    
    private func setupContentLayout() {
        view.addSubview(contentStackView)
        contentStackView.addArrangedSubview(characterImageView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        
        contentStackView.snp.makeConstraints {
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-80)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        characterImageView.snp.makeConstraints {
            $0.width.height.equalTo(220)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        contentStackView.setCustomSpacing(24, after: characterImageView)
    }
    
    private func setupButtonLayout() {
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(button)
        buttonStackView.addArrangedSubview(signInOptionLabel)
        buttonStackView.addArrangedSubview(kakaoButton)
        buttonStackView.addArrangedSubview(appleButton)
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
        }
        
        [button, kakaoButton, appleButton].forEach { button in
            button.snp.makeConstraints {
                $0.height.equalTo(54)
            }
        }
        
        buttonStackView.setCustomSpacing(20, after: button)
        buttonStackView.setCustomSpacing(10, after: signInOptionLabel)
    }
    
    private static func makeSignInButton(
        title: String,
        image: UIImage,
        backgroundColor: UIColor,
        foregroundColor: UIColor
    ) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = .systemFont(ofSize: 15, weight: .bold)
        config.attributedTitle = attributedTitle
        config.image = image.resized(to: CGSize(width: 22, height: 22))
        config.imagePlacement = .leading
        config.imagePadding = 8
        
        return UIButton(configuration: config)
    }
    
    func bind(reactor: SignInReactor) {
        button.rx.tap
            .map { SignInReactor.Action.mainbuttonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        kakaoButton.rx.tap
            .map { SignInReactor.Action.kakaoButtonTapped }
            .bind(to: reactor.action )
            .disposed(by: disposeBag)
        
        appleButton.rx.tap
            .map { SignInReactor.Action.appleButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
