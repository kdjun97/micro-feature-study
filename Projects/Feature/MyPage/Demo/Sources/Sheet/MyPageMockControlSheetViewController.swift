import MyPageTesting
import ReactorKit
import RxCocoa
import RxSwift
import UIKit

final class MyPageMockControlSheetViewController: UIViewController, View {
    var disposeBag = DisposeBag()

    private let sheetReactor: MyPageMockSheetReactor
    private let onActionSelected: (MyPageDemoReactor.MockAction) -> Void
    private var itemButtons: [(button: UIButton, item: MyPageMockSheetReactor.Item)] = []

    init(
        reactor: MyPageMockSheetReactor,
        onActionSelected: @escaping (MyPageDemoReactor.MockAction) -> Void
    ) {
        self.sheetReactor = reactor
        self.onActionSelected = onActionSelected
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout(state: sheetReactor.initialState)
        reactor = sheetReactor
    }

    func bind(reactor: MyPageMockSheetReactor) {
        itemButtons.forEach { button, item in
            button.rx.tap
                .map { MyPageMockSheetReactor.Action.itemTapped(item) }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }

        reactor.selectedAction
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                guard let self else { return }
                self.dismiss(animated: true) {
                    self.onActionSelected(action)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupLayout(state: MyPageMockSheetReactor.State) {
        let titleLabel = UILabel()
        titleLabel.text = "MyPage Mock"
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .label

        let summaryLabel = UILabel()
        summaryLabel.text = state.mockState.summaryText
        summaryLabel.font = .systemFont(ofSize: 14, weight: .medium)
        summaryLabel.textColor = .secondaryLabel
        summaryLabel.numberOfLines = 0

        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, summaryLabel])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        state.items.forEach { item in
            let button = makeButton(for: item)
            itemButtons.append((button, item))
            stackView.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func makeButton(for item: MyPageMockSheetReactor.Item) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = item.title
        configuration.baseBackgroundColor = item.isDestructive ? .systemRed : .systemBlue
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium

        let button = UIButton(configuration: configuration)
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return button
    }
}

private extension MyPageMockState {
    var summaryText: String {
        "현재 \(userName) · \(emotionRecordCount)개 · v\(appVersion)"
    }
}

private extension MyPageMockSheetReactor.Item {
    var title: String {
        switch self {
        case .preset(let preset):
            preset.title
        case .reset:
            "초기화"
        }
    }

    var isDestructive: Bool {
        switch self {
        case .preset(.logoutFailure):
            true
        case .preset, .reset:
            false
        }
    }
}
