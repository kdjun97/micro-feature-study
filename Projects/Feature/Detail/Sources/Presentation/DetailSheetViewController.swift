import UIKit
import DesignSystem
import SnapKit

final class DetailSheetViewController: UIViewController {
    private let grabberSpaceView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "잠깐 쉬어가도 괜찮아요"
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 화면은 실제 기능을 바꾸지 않고, 상세 흐름에서 보여줄 안내 메시지의 분위기를 확인하기 위한 시트예요."
        label.textColor = .gray6
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()

    private let firstRow = DetailSheetRowView(
        title: "감정 기록 흐름",
        message: "홈에서 상세로 이어지는 맥락을 확인해요.",
        accentColor: .main
    )

    private let secondRow = DetailSheetRowView(
        title: "안내 메시지 표현",
        message: "바텀시트가 비어 보이지 않도록 정보를 채웠어요.",
        accentColor: .sub
    )

    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "내일 데모에서는 이 화면을 통해 상세 이후의 보조 안내 경험을 보여줄 수 있어요."
        label.textColor = .gray5
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
    }

    deinit {
        print("❎ DetailSheetViewController deinit!")
    }

    private func setupLayout() {
        view.addSubview(grabberSpaceView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(contentStackView)
        view.addSubview(noteLabel)

        contentStackView.addArrangedSubview(firstRow)
        contentStackView.addArrangedSubview(secondRow)

        grabberSpaceView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(18)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(grabberSpaceView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        contentStackView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        noteLabel.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
}

private final class DetailSheetRowView: UIView {
    private let accentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .uBlack
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray6
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        return label
    }()

    init(title: String, message: String, accentColor: UIColor) {
        super.init(frame: .zero)
        titleLabel.text = title
        messageLabel.text = message
        accentView.backgroundColor = accentColor
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .gray1
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }

    private func setupLayout() {
        addSubview(accentView)
        addSubview(titleLabel)
        addSubview(messageLabel)

        accentView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(12)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(accentView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }

        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(titleLabel)
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
    }
}
