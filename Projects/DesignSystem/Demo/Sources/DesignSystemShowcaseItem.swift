import UIKit

enum DesignSystemShowcaseItem: CaseIterable {
    case button
    case textField
    case alert
    case navigationBar
    case colors
    case images

    var title: String {
        switch self {
        case .button: "Button"
        case .textField: "TextField"
        case .alert: "Alert"
        case .navigationBar: "Navigation Bar"
        case .colors: "Colors"
        case .images: "Images"
        }
    }

    var subtitle: String {
        switch self {
        case .button: "CustomButton 상태별 샘플"
        case .textField: "CustomTextField 입력 케이스"
        case .alert: "CustomAlert 단일/이중 액션"
        case .navigationBar: "Large/Inline title, toolbar, push flow"
        case .colors: "DesignSystem UIColor 토큰"
        case .images: "DesignSystem UIImage 에셋"
        }
    }

    var symbolName: String {
        switch self {
        case .button: "rectangle.and.hand.point.up.left.fill"
        case .textField: "text.cursor"
        case .alert: "exclamationmark.bubble.fill"
        case .navigationBar: "menubar.rectangle"
        case .colors: "paintpalette.fill"
        case .images: "photo.on.rectangle.angled"
        }
    }

    func makeViewController() -> UIViewController {
        switch self {
        case .button: ButtonShowcaseViewController()
        case .textField: TextFieldShowcaseViewController()
        case .alert: AlertShowcaseViewController()
        case .navigationBar: NavigationBarShowcaseViewController()
        case .colors: ColorShowcaseViewController()
        case .images: ImageShowcaseViewController()
        }
    }
}
