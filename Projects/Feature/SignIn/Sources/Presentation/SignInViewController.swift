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
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "SignInViewController"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let button: UIButton = CustomButton(
        title: "Go To Main",
        backgroundColor: .black,
        foregroundColor: .white
    )
    
    private let kakaoButton: UIButton = {
        let button = UIButton()
        button.setImage(.icKakao, for: .normal)
        
        return button
    }()
    
    private let appleButton: UIButton = {
        let button = UIButton()
        button.setImage(.icApple, for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        setupLayout()
        setBottomButtonLayout()
    }
    
    private func setupLayout() {
        view.addSubview(label)
        view.addSubview(button)
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(label).offset(40)
            $0.centerX.equalTo(label)
        }
    }
    
    func setBottomButtonLayout() {
        let container = UIView()
        view.addSubview(container)
        
        container.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
        }
        
        container.addSubview(kakaoButton)
        container.addSubview(appleButton)

        kakaoButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }

        appleButton.snp.makeConstraints {
            $0.leading.equalTo(kakaoButton.snp.trailing).offset(48)
            $0.trailing.top.bottom.equalToSuperview()
        }
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
