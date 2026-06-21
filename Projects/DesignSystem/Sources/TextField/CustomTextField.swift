//
//  CustomTextField.swift
//  UIKitPlayGround
//
//  Created by 김동준 on 12/18/25
//

import UIKit

public final class CustomTextField: UITextField {
    public override init(frame: CGRect = .zero) {
        super.init(frame: .zero)
        setupReturnKeyDismiss()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let padding = UIEdgeInsets(
        top: 18,
        left: 20,
        bottom: 18,
        right: 20
    )

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

private extension CustomTextField {
    func setupReturnKeyDismiss() {
        addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
    }
    
    @objc func dismissKeyboard() {
        resignFirstResponder()
    }
}
