import UIKit
import DesignSystem
import Base

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    
    deinit {
        print("❎ DetailViewController deinit!")
    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        print("⭕ DetailViewController init!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Detail Header"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let sheetButton = CustomButton(
        title: "Sheet 버튼",
        backgroundColor: .black,
        foregroundColor: .white
    )
    
    private let tabBarContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLayout()
        sheetButton.addTarget(self, action: #selector(sheetButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(headerLabel)
        view.addSubview(sheetButton)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        sheetButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sheetButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            sheetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func sheetButtonTapped() {
        viewModel.send(.sheetButtonTapped)
    }
}

extension DetailViewController: SwipeBackEventReceivable {
    func swipeBackDidCancel() {
        print("Did Cancel")
    }
    
    func swipeBackDidComplete() {
        print("Swipe Completed")
    }
}
