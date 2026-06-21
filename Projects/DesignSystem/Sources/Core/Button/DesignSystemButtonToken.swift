//
//  DesignSystemButtonToken.swift
//  DesignSystem
//
//  Created by 김동준 on 6/21/26
//

import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif

public enum DesignSystemButtonVariant: Sendable {
    case primary
    case secondary
    case destructive

    public func backgroundColor(isEnabled: Bool) -> UIColor {
        guard isEnabled else { return DesignSystemColor.gray2.uiColor }

        return switch self {
        case .primary: DesignSystemColor.primaryMain.uiColor
        case .secondary: DesignSystemColor.gray1.uiColor
        case .destructive: UIColor.systemRed
        }
    }

    public func foregroundColor(isEnabled: Bool) -> UIColor {
        guard isEnabled else { return DesignSystemColor.textBlack.uiColor }

        return switch self {
        case .primary, .destructive: UIColor.white
        case .secondary: DesignSystemColor.textBlack.uiColor
        }
    }
}

public enum DesignSystemButtonSize: Sendable {
    case medium
    case large

    public var contentInsets: NSDirectionalEdgeInsets {
        switch self {
        case .medium:
            NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        case .large:
            NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        }
    }

    public var uiFont: UIFont {
        switch self {
        case .medium: .systemFont(ofSize: 15, weight: .semibold)
        case .large: .systemFont(ofSize: 16, weight: .semibold)
        }
    }

    public var textLineHeight: CGFloat {
        ceil(uiFont.lineHeight)
    }

    #if canImport(SwiftUI)
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
    public var swiftUIFont: SwiftUI.Font {
        switch self {
        case .medium: .system(size: 15, weight: .semibold)
        case .large: .system(size: 16, weight: .semibold)
        }
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
    public var swiftUIEdgeInsets: SwiftUI.EdgeInsets {
        SwiftUI.EdgeInsets(
            top: contentInsets.top,
            leading: contentInsets.leading,
            bottom: contentInsets.bottom,
            trailing: contentInsets.trailing
        )
    }
    #endif
}

public enum DesignSystemButtonToken {
    public static let cornerRadius: CGFloat = 12
    public static let disabledOpacity: CGFloat = 0.45
    public static let rippleOpacity: CGFloat = 0.18
    public static let rippleDuration: TimeInterval = 0.42
}

#if canImport(SwiftUI)
extension UIColor {
    var swiftUIColor: SwiftUI.Color {
        SwiftUI.Color(self)
    }
}
#endif
