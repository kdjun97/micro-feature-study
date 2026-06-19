import UIKit
import DesignSystem

final class NavigationBarShowcaseViewController: ShowcaseViewController {
    private var displayMode: UINavigationItem.LargeTitleDisplayMode = .automatic

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Navigation Bar"
        navigationItem.largeTitleDisplayMode = displayMode
        configureBarButtonItems()

        addSection(
            title: "Title Display Mode",
            description: "Navigation bar title 표시 방식을 버튼으로 전환합니다.",
            arrangedSubviews: [
                makeModeButton(title: "Large Title", mode: .always),
                makeModeButton(title: "Inline Title", mode: .never),
                makeModeButton(title: "Automatic", mode: .automatic)
            ]
        )

        addSection(
            title: "Push Flow",
            description: "NavigationLink와 유사한 push/back 동작을 UIKit UINavigationController로 확인합니다.",
            arrangedSubviews: [makePushButton()]
        )
    }

    private func configureBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bell.fill"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .main
    }

    private func makeModeButton(
        title: String,
        mode: UINavigationItem.LargeTitleDisplayMode
    ) -> UIButton {
        let button = CustomButton(
            title: title,
            backgroundColor: .gray1,
            foregroundColor: .uBlack,
            edgeInsets: NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        )
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addAction(UIAction { [weak self] _ in
            self?.navigationItem.largeTitleDisplayMode = mode
            self?.navigationController?.navigationBar.setNeedsLayout()
        }, for: .touchUpInside)
        return button
    }

    private func makePushButton() -> UIButton {
        let button = CustomButton(
            title: "Detail 화면 Push",
            backgroundColor: .main,
            foregroundColor: .white,
            edgeInsets: NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        )
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addAction(UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(NavigationDetailViewController(), animated: true)
        }, for: .touchUpInside)
        return button
    }

    @objc private func rightBarButtonTapped() {
        let alertController = UIAlertController(
            title: "Right Bar Button",
            message: "navigationItem.rightBarButtonItem 액션입니다.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}

private final class NavigationDetailViewController: ShowcaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pushed Detail"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .main

        addSection(
            title: "Detail",
            description: "Back 버튼과 Done toolbar item을 확인할 수 있는 상세 화면입니다.",
            arrangedSubviews: [makeDescriptionLabel("UIKit에서는 UINavigationController.pushViewController로 화면 전환을 구성합니다.")]
        )
    }

    @objc private func doneButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
