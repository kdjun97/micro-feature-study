import UIKit
import DesignSystem
import SnapKit
import Combine

class SignInDetailViewController: UIViewController {
    private let viewModel: SignInDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    deinit {
        print("❎ SignInDetailViewController deinit!")
    }
    
    init(viewModel: SignInDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("⭕ SignInDetailViewController init!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let navigationContainer = UIView()
        
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.icArrowLeft, for: .normal)
        return button
    }()
    
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 설정"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
    
    private let guideLabelContainer: UIView = UIView()
    
    private let welcomeText: UILabel = {
        let label = UILabel()
        label.text = "환영해요!"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()

    private let inputNicknameText: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 입력해주세요"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private let textField: UITextField = {
        let textField = CustomTextField()
        textField.setPlaceholder(color: .gray3)
        textField.placeholder = "닉네임을 입력해주세요."
        textField.font = .systemFont(ofSize: 16, weight: .medium)
        textField.textColor = .uBlack
        textField.borderStyle = .none
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 12
        textField.backgroundColor = .gray1
        textField.returnKeyType = .done

        return textField
    }()
    
    private let bottomButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "완료"
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
        config.baseBackgroundColor = .gray1
        config.baseForegroundColor = .gray5
        
        return UIButton(configuration: config)
    }()
    
    private let errorMessageContainer = UIView()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 1
        label.text = nil
        label.isHidden = true
        
        return label
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupLayout()
        setAction()
        bind()
        setupKeyboardDismissEvent()
    }
}

private extension SignInDetailViewController {
    func setUI() {
        view.backgroundColor = .systemBackground
    }
    
    func setupLayout() {
        setupNavigationBar()
        setupGuideText()
        setupTextField()
        setupBottomButton()
    }

    func setupNavigationBar() {
        view.addSubview(navigationContainer)
        navigationContainer.addSubview(navigationTitleLabel)
        navigationContainer.addSubview(backButton)

        navigationContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.leading.equalToSuperview()
        }
                
        navigationTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setupGuideText() {
        view.addSubview(guideLabelContainer)
        guideLabelContainer.addSubview(welcomeText)
        guideLabelContainer.addSubview(inputNicknameText)
        
        guideLabelContainer.snp.makeConstraints {
            $0.top.equalTo(navigationContainer.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        welcomeText.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        inputNicknameText.snp.makeConstraints {
            $0.top.equalTo(welcomeText.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupTextField() {
        view.addSubview(textFieldStackView)
        textFieldStackView.addArrangedSubview(textField)
        textFieldStackView.addArrangedSubview(errorMessageContainer)
        errorMessageContainer.addSubview(errorMessageLabel)
        
        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(guideLabelContainer.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
                
        textField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        errorMessageLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func setupBottomButton() {
        view.addSubview(bottomButton)
        bottomButton.snp.makeConstraints {
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}

private extension SignInDetailViewController {
    func setAction() {
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        textField.addTarget(self, action: #selector(nicknameDidChange), for: .editingChanged)
    }
    
    @objc func backButtonAction() {
        viewModel.send(.backButtonTapped)
    }
    
    @objc private func nicknameDidChange(_ textField: UITextField) {
        viewModel.send(.nicknameChanged(textField.text ?? ""))
    }
}

private extension SignInDetailViewController {
    func bind() {
        viewModel.$isNicknameValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                guard let self = self else { return }
                self.updateBottomButton(isEnabled: isValid)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                self.updateErrorLabel(message: errorMessage)
            }
            .store(in: &cancellables)
    }
    
    func updateBottomButton(isEnabled: Bool) {
        var config = bottomButton.configuration
        config?.baseBackgroundColor = isEnabled ? .main : .gray1
        config?.baseForegroundColor = isEnabled ? .white : .gray5
        bottomButton.configuration = config
        bottomButton.isEnabled = isEnabled
    }
    
    func updateErrorLabel(message: String?) {
        if let message = message {
            errorMessageLabel.text = message
            errorMessageLabel.textColor = .red
            errorMessageLabel.isHidden = false
        } else {
            errorMessageLabel.isHidden = true
            errorMessageLabel.text = nil
        }
    }
}
