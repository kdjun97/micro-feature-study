//
//  UITextField+.swift
//  UIKitPlayGround
//
//  Created by 김동준 on 12/18/25
//

import UIKit

public extension UITextField {
    func setPlaceholder(
        color: UIColor,
        font: UIFont = .systemFont(ofSize: 16, weight: .medium)
    ) {
        guard let string = self.placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: string,
            attributes: [
                .foregroundColor: color,
                .font: font
            ]
        )
    }
}
