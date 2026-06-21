//
//  CustomButton.swift
//  UIKitPlayGround
//
//  Created by 김동준 on 12/10/25
//

import UIKit

final public class CustomButton: UIButton {
    public init(
        title: String,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        edgeInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 10, bottom: 10, trailing: 10
        )
    ) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.contentInsets = edgeInsets
        config.baseBackgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        
        super.init(frame: .zero)
        self.configuration = config
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
