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
