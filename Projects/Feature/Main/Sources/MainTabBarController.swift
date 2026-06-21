import UIKit
import DesignSystem

public final class MainTabBarController: UITabBarController {
    private weak var currentOverlayView: UIView?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureTabBarAppearance()
    }

    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .separator
        applySelectedColor(to: appearance.stackedLayoutAppearance)
        applySelectedColor(to: appearance.inlineLayoutAppearance)
        applySelectedColor(to: appearance.compactInlineLayoutAppearance)

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .main
    }

    private func applySelectedColor(to itemAppearance: UITabBarItemAppearance) {
        itemAppearance.selected.iconColor = .main
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.main
        ]
    }

    deinit {
        print("❎ MainTabBarController deinit!")
    }

    func setTabs(_ tabs: [MainTabRoot], animated: Bool) {
        let viewControllers = tabs.map { root in
            root.viewController.tabBarItem = root.tab.tabBarItem
            return root.viewController
        }
        setViewControllers(viewControllers, animated: animated)
    }

    func showOverlay(_ overlayView: UIView) {
        currentOverlayView?.removeFromSuperview()

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        currentOverlayView = overlayView
    }
}
