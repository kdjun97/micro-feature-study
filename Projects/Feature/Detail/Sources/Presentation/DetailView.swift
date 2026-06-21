import UIKit
import DesignSystem
import Base
import SnapKit

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

    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록 상세"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .uBlack
        label.textAlignment = .center
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 기록"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .uBlack
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 표시할 상세 내용이 없습니다."
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .gray6
        label.numberOfLines = 0
        return label
    }()

    private let sheetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .main
        config.baseForegroundColor = .white
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20)

        var title = AttributedString("안내 시트 열기")
        title.font = .systemFont(ofSize: 17, weight: .bold)
        config.attributedTitle = title

        return UIButton(configuration: config)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupLayout()
        sheetButton.addTarget(self, action: #selector(sheetButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        view.addSubview(navigationTitleLabel)
        view.addSubview(contentStackView)
        view.addSubview(sheetButton)

        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)

        navigationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        contentStackView.snp.makeConstraints {
            $0.top.equalTo(navigationTitleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualTo(sheetButton.snp.top).offset(-24)
        }

        sheetButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            $0.height.equalTo(56)
        }
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
