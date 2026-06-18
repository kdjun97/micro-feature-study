import UIKit
import DesignSystem
import SnapKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private weak var currentAlert: CustomAlert?
    
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
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "HomeViewController"
        label.textColor = .black

        return label
    }()
    
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "바닥 텍스트입니다"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let detailButton = CustomButton(
        title: "Go To Detail",
        backgroundColor: .red,
        foregroundColor: .white
    )
    
    private let tipAlertButton = CustomButton(
        title: "Show Tip Alert",
        backgroundColor: .orange,
        foregroundColor: .white
    )
    
    private let stopEditingAlertButton = CustomButton(
        title: "Show Stop Editing Alert",
        backgroundColor: .black,
        foregroundColor: .white
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        setupLayout()
        bind()
        setAction()
    }
    
    private func setupLayout() {
        view.addSubview(label)
        view.addSubview(detailButton)
        view.addSubview(bottomLabel)
        view.addSubview(tipAlertButton)
        view.addSubview(stopEditingAlertButton)

        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.safeAreaLayoutGuide)
        }
        
        detailButton.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        bottomLabel.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        tipAlertButton.snp.makeConstraints {
            $0.top.equalTo(detailButton.snp.bottom).offset(48)
            $0.centerX.equalToSuperview()
        }

        stopEditingAlertButton.snp.makeConstraints {
            $0.top.equalTo(tipAlertButton.snp.bottom).offset(48)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension HomeViewController {
    func bind() {
        viewModel.onViewState = { [weak self] viewState in
            Task { @MainActor [weak self] in
                switch viewState {
                case .showAlert(let alertCase):
                    self?.renderAlert(alertCase)
                }
            }
        }
    }

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

extension HomeViewController {
    func renderAlert(_ alertCase: HomeAlertCase?) {
        currentAlert?.removeFromSuperview()
        guard let alertCase else { return }

        let alert = CustomAlert(
            title: alertCase.title,
            contents: alertCase.contents,
            primaryButtonTitle: alertCase.primaryButtonTitle,
            secondaryButtonTitle: alertCase.secondaryButtonTitle,
            isDismissable: alertCase.isDismissable
        )
        view.addSubview(alert)
        alert.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        currentAlert = alert
    }
}

private extension HomeAlertCase {
    var title: String {
        switch self {
        case .tip:
            "[꿀팁] 테스트 꿀팁!"
        case .stopEditing:
            "편집을 중단할까요?"
        }
    }

    var contents: String {
        switch self {
        case .tip:
            "어떤게 꿀팁이 될 수 있을지 잘 모르겠지만 일단은 적어봄."
        case .stopEditing:
            "편집을 중단하시면 지금까지 수정한 내용이 모두 삭제됩니다."
        }
    }

    var primaryButtonTitle: String {
        "닫기"
    }

    var secondaryButtonTitle: String? {
        switch self {
        case .tip:
            nil
        case .stopEditing:
            "확인"
        }
    }

    var isDismissable: Bool {
        switch self {
        case .tip:
            true
        case .stopEditing:
            false
        }
    }
}
