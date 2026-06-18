import UIKit

public final class MainTabBarController: UITabBarController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tabBar.backgroundColor = .white
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
}
