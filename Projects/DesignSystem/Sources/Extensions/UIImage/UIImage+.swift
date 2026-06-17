//
//  UIImage+.swift
//  UIKitPlayGround
//
//  Created by 김동준 on 12/22/25
//

import UIKit

public extension UIImage {
    static var icCharacter: UIImage { DesignSystemAsset.Images.icCharacter.image }
    static var icApple: UIImage { DesignSystemAsset.Images.icApple.image }
    static var icArrowLeft: UIImage { DesignSystemAsset.Images.icArrowLeft.image }
    static var icArrowRight: UIImage { DesignSystemAsset.Images.icArrowRight.image }
    static var icKakao: UIImage { DesignSystemAsset.Images.icKakao.image }

    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
