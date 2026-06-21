//
//  DesignSystemColor.swift
//  DesignSystem
//
//  Created by 김동준 on 6/21/26
//

import UIKit

#if canImport(SwiftUI)
import SwiftUI
#endif

public enum DesignSystemColor: Sendable {
    case buddhism
    case possibility
    case primaryBright
    case primaryMain
    case primaryMedium
    case primarySub
    case gray1
    case gray2
    case gray3
    case gray4
    case gray5
    case gray6
    case textBlack

    public var uiColor: UIColor {
        asset.color
    }

    #if canImport(SwiftUI)
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, visionOS 1.0, *)
    public var swiftUIColor: SwiftUI.Color {
        asset.swiftUIColor
    }
    #endif
}

private extension DesignSystemColor {
    var asset: DesignSystemColors {
        switch self {
        case .buddhism: DesignSystemAsset.Colors.buddhism
        case .possibility: DesignSystemAsset.Colors.possibility
        case .primaryBright: DesignSystemAsset.Colors.bright
        case .primaryMain: DesignSystemAsset.Colors.main
        case .primaryMedium: DesignSystemAsset.Colors.medium
        case .primarySub: DesignSystemAsset.Colors.sub
        case .gray1: DesignSystemAsset.Colors.gray1
        case .gray2: DesignSystemAsset.Colors.gray2
        case .gray3: DesignSystemAsset.Colors.gray3
        case .gray4: DesignSystemAsset.Colors.gray4
        case .gray5: DesignSystemAsset.Colors.gray5
        case .gray6: DesignSystemAsset.Colors.gray6
        case .textBlack: DesignSystemAsset.Colors.uBlack
        }
    }
}
