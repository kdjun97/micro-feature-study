//
//  CustomButton.swift
//  UIKitPlayGround
//
//  Created by 김동준 on 12/10/25
//

import UIKit

final public class CustomButton: UIButton {
    public typealias Variant = DesignSystemButtonVariant
    public typealias Size = DesignSystemButtonSize

    struct CustomAppearance {
        let backgroundColor: UIColor
        let foregroundColor: UIColor
        let edgeInsets: NSDirectionalEdgeInsets
    }

    private var customAppearance: CustomAppearance?
    private var buttonTitle: String

    public var variant: Variant {
        didSet {
            customAppearance = nil
            applyConfiguration()
        }
    }

    public var size: Size {
        didSet { applyConfiguration() }
    }

    public override var isEnabled: Bool {
        didSet { applyConfiguration() }
    }

    public override var isHighlighted: Bool {
        didSet { applyInteractionState() }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard isEnabled, let location = touches.first?.location(in: self) else { return }
        showRipple(at: location)
    }

    public init(
        title: String,
        variant: Variant = .primary,
        size: Size = .large
    ) {
        self.buttonTitle = title
        self.variant = variant
        self.size = size

        super.init(frame: .zero)

        setupButton()
        applyConfiguration()
    }

    public convenience init(
        title: String,
        backgroundColor: UIColor,
        foregroundColor: UIColor,
        edgeInsets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(
            top: 10, leading: 10, bottom: 10, trailing: 10
        )
    ) {
        self.init(title: title)

        customAppearance = CustomAppearance(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            edgeInsets: edgeInsets
        )
        applyConfiguration()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setTitle(_ title: String) {
        buttonTitle = title
        applyConfiguration()
    }
}

private extension CustomButton {
    func setupButton() {
        layer.cornerRadius = DesignSystemButtonToken.cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
        adjustsImageWhenHighlighted = false
    }

    func applyConfiguration() {
        let buttonSize = size
        let appearance = customAppearance
        let foregroundColor = resolvedForegroundColor(for: appearance)
        let contentInsets = appearance?.edgeInsets ?? buttonSize.contentInsets

        configuration = nil
        setTitle(buttonTitle, for: .normal)
        setTitle(buttonTitle, for: .disabled)
        setTitleColor(foregroundColor, for: .normal)
        setTitleColor(foregroundColor, for: .disabled)
        titleLabel?.font = buttonSize.uiFont
        backgroundColor = resolvedBackgroundColor(for: appearance)
        contentEdgeInsets = UIEdgeInsets(
            top: contentInsets.top,
            left: contentInsets.leading,
            bottom: contentInsets.bottom,
            right: contentInsets.trailing
        )
        applyInteractionState()
    }

    func applyInteractionState() {
        alpha = isEnabled ? 1 : DesignSystemButtonToken.disabledOpacity
    }

    func showRipple(at location: CGPoint) {
        let diameter = max(bounds.width, bounds.height) * 1.35
        let initialFrame = CGRect(origin: location, size: .zero)
        let finalFrame = CGRect(
            x: location.x - diameter / 2,
            y: location.y - diameter / 2,
            width: diameter,
            height: diameter
        )

        let rippleLayer = CALayer()
        rippleLayer.frame = initialFrame
        rippleLayer.cornerRadius = diameter / 2
        rippleLayer.backgroundColor = resolvedForegroundColor(for: customAppearance)
            .withAlphaComponent(DesignSystemButtonToken.rippleOpacity)
            .cgColor
        layer.insertSublayer(rippleLayer, below: titleLabel?.layer)

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            rippleLayer.removeFromSuperlayer()
        }

        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: CGRect(origin: .zero, size: .zero))
        boundsAnimation.toValue = NSValue(cgRect: CGRect(origin: .zero, size: finalFrame.size))

        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = NSValue(cgPoint: location)
        positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: finalFrame.midX, y: finalFrame.midY))

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [boundsAnimation, positionAnimation, opacityAnimation]
        animationGroup.duration = DesignSystemButtonToken.rippleDuration
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)

        rippleLayer.add(animationGroup, forKey: "ripple")
        CATransaction.commit()
    }

    func resolvedBackgroundColor(for appearance: CustomAppearance?) -> UIColor {
        if let appearance, isEnabled {
            return appearance.backgroundColor
        }
        return variant.backgroundColor(isEnabled: isEnabled)
    }

    func resolvedForegroundColor(for appearance: CustomAppearance?) -> UIColor {
        if let appearance, isEnabled {
            return appearance.foregroundColor
        }
        return variant.foregroundColor(isEnabled: isEnabled)
    }
}
