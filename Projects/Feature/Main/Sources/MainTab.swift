import UIKit

public enum MainTab: Int, CaseIterable {
    case dashboard = 0
    case myPage = 1
}

public struct MainTabRoot {
    let tab: MainTab
    let viewController: UIViewController

    public init(tab: MainTab, viewController: UIViewController) {
        self.tab = tab
        self.viewController = viewController
    }
}

extension MainTab {
    var tabBarItem: UITabBarItem {
        switch self {
        case .dashboard:
            UITabBarItem(
                title: "홈",
                image: UIImage(systemName: "house"),
                selectedImage: UIImage(systemName: "house.fill")
            )
        case .myPage:
            UITabBarItem(
                title: "마이",
                image: UIImage(systemName: "person"),
                selectedImage: UIImage(systemName: "person.fill")
            )
        }
    }
}
