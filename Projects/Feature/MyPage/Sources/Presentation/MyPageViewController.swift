import DesignSystem
import MyPageInterface
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class MyPageViewController: UIViewController, View {
    var disposeBag = DisposeBag()

    deinit {
        print("❎ MyPageViewController deinit!")
    }

    init(reactor: MyPageReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
        print("⭕ MyPageViewController init!")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let navigationBar: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private let userInfoContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .bright
        view.layer.cornerRadius = 12
        return view
    }()

    private let nameButton: UIButton = {
        var config = UIButton.Configuration.plain()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.uBlack
        ]
        let title = NSAttributedString(string: "", attributes: attributes)
        config.attributedTitle = AttributedString(title)
        config.image = .icArrowRight.resized(to: CGSize(width: 14, height: 14))
        config.imagePlacement = .trailing
        config.imagePadding = 0
        config.titleLineBreakMode = .byTruncatingTail
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        let button = UIButton(configuration: config)
        button.configuration?.baseForegroundColor = .uBlack
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private let userInfoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray6
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    private let sendOpinionButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .main
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 24, bottom: 10, trailing: 24)

        var title = AttributedString("시미에게 의견 보내기")
        title.font = .systemFont(ofSize: 15, weight: .bold)
        config.attributedTitle = title

        return UIButton(configuration: config)
    }()

    private let characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .icCharacter
        return imageView
    }()

    private let changeNameButton = CustomButton(
        title: "Change Name",
        backgroundColor: .black,
        foregroundColor: .white
    )

    private let changeCountButton = CustomButton(
        title: "카운터 증가",
        backgroundColor: .blue,
        foregroundColor: .white
    )

    private let supportLabel: UILabel = {
        let label = UILabel()
        label.text = "고객지원"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    private let myPageTableView = MyPageTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        reactor?.action.onNext(.viewDidLoad)
    }
}

extension MyPageViewController {
    func bind(reactor: MyPageReactor) {
        bindState(reactor)
        bindAction(reactor)
    }

    func bindState(_ reactor: MyPageReactor) {
        reactor.state
            .map(\.name)
            .distinctUntilChanged()
            .bind { [weak self] name in
                guard let self else { return }
                var config = self.nameButton.configuration
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 18, weight: .bold),
                    .foregroundColor: UIColor.uBlack
                ]
                let title = NSAttributedString(string: name, attributes: attributes)
                config?.attributedTitle = AttributedString(title)
                self.nameButton.configuration = config
            }
            .disposed(by: disposeBag)

        reactor.state
            .map { "\($0.count)개의 감정기록이 담겨있네요!\n시미가 당신의 의견을 기다리고 있어요" }
            .distinctUntilChanged()
            .bind(to: userInfoDescriptionLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { state in
                state.supportItems.enumerated().map { index, item in
                    SupportCellModel(
                        item: item,
                        index: index,
                        totalCount: state.supportItems.count,
                        appVersion: state.appVersion
                    )
                }
            }
            .distinctUntilChanged()
            .bind(
                to: myPageTableView.rx.items(
                    cellIdentifier: SupportCell.identifier,
                    cellType: SupportCell.self
                )
            ) { _, model, cell in
                cell.configure(model)
            }
            .disposed(by: disposeBag)
    }

    func bindAction(_ reactor: MyPageReactor) {
        changeNameButton.rx.tap
            .map { MyPageReactor.Action.changeNameButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        changeCountButton.rx.tap
            .map { MyPageReactor.Action.updateCountButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nameButton.rx.tap
            .map { MyPageReactor.Action.changeNameButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myPageTableView.rx.modelSelected(SupportCellModel.self)
            .map { MyPageReactor.Action.supportItemTapped($0.item) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        myPageTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.myPageTableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

private extension MyPageViewController {
    func setupLayout() {
        setupDefaultLayout()
        setUserInfoLayout()
        setSupportLayout()
    }

    func setupDefaultLayout() {
        view.addSubview(navigationBar)
        view.addSubview(changeNameButton)
        view.addSubview(changeCountButton)

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.leading.equalToSuperview()
        }

        changeNameButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        changeCountButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(changeNameButton.snp.trailing).offset(48)
        }
    }

    func setUserInfoLayout() {
        view.addSubview(userInfoContainer)
        userInfoContainer.addSubview(nameButton)
        userInfoContainer.addSubview(userInfoDescriptionLabel)
        userInfoContainer.addSubview(sendOpinionButton)
        userInfoContainer.addSubview(characterImage)

        userInfoContainer.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(24)
            $0.trailing.leading.equalToSuperview().inset(20)
        }

        nameButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(characterImage.snp.leading).offset(-12)
        }

        userInfoDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameButton.snp.bottom).offset(12)
            $0.leading.equalTo(nameButton.snp.leading)
            $0.trailing.lessThanOrEqualTo(characterImage.snp.leading).offset(-12)
        }

        sendOpinionButton.snp.makeConstraints {
            $0.top.equalTo(userInfoDescriptionLabel.snp.bottom).offset(12)
            $0.leading.equalTo(nameButton.snp.leading)
            $0.bottom.equalToSuperview().inset(24)
        }

        characterImage.snp.makeConstraints {
            $0.centerY.equalTo(userInfoContainer)
            $0.trailing.equalTo(userInfoContainer.snp.trailing)
            $0.width.height.equalTo(100)
        }
    }

    func setSupportLayout() {
        view.addSubview(supportLabel)
        view.addSubview(myPageTableView)

        supportLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoContainer.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(supportLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(changeNameButton.snp.top)
        }
    }
}
