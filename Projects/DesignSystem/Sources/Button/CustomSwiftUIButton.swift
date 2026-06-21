//
//  CustomSwiftUIButton.swift
//  DesignSystem
//
//  Created by 김동준 on 6/21/26
//

#if canImport(SwiftUI)
import SwiftUI
import UIKit

public struct CustomSwiftUIButton: View {
    private let title: String
    private let variant: DesignSystemButtonVariant
    private let size: DesignSystemButtonSize
    private let isEnabled: Bool
    private let action: () -> Void

    @State private var isPressing = false
    @State private var rippleLocation = CGPoint.zero
    @State private var rippleScale: CGFloat = 0.01
    @State private var rippleOpacity: CGFloat = 0

    public init(
        title: String,
        variant: DesignSystemButtonVariant = .primary,
        size: DesignSystemButtonSize = .large,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: performAction) {
            Text(title)
                .font(size.swiftUIFont)
                .foregroundColor(variant.foregroundColor(isEnabled: isEnabled).swiftUIColor)
                .frame(height: size.textLineHeight)
                .padding(size.swiftUIEdgeInsets)
                .frame(maxWidth: .infinity)
                .background(variant.backgroundColor(isEnabled: isEnabled).swiftUIColor)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: DesignSystemButtonToken.cornerRadius,
                        style: .continuous
                    )
                )
                .overlay {
                    GeometryReader { proxy in
                        Circle()
                            .fill(rippleColor.opacity(DesignSystemButtonToken.rippleOpacity))
                            .frame(width: rippleDiameter(in: proxy), height: rippleDiameter(in: proxy))
                            .scaleEffect(rippleScale)
                            .opacity(rippleOpacity)
                            .position(resolvedRippleLocation(in: proxy))
                    }
                }
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: DesignSystemButtonToken.cornerRadius,
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .opacity(isEnabled ? 1 : DesignSystemButtonToken.disabledOpacity)
        .allowsHitTesting(isEnabled)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    guard isEnabled, !isPressing else { return }
                    isPressing = true
                    triggerRipple(at: value.location)
                }
                .onEnded { _ in
                    isPressing = false
                }
        )
    }

    private func performAction() {
        guard isEnabled else { return }
        action()
    }

    private var rippleColor: Color {
        variant.foregroundColor(isEnabled: isEnabled).swiftUIColor
    }

    private func resolvedRippleLocation(in proxy: GeometryProxy) -> CGPoint {
        if rippleLocation == .zero {
            return CGPoint(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        return rippleLocation
    }

    private func rippleDiameter(in proxy: GeometryProxy) -> CGFloat {
        max(proxy.size.width, proxy.size.height) * 1.35
    }

    private func triggerRipple(at location: CGPoint) {
        rippleLocation = location
        rippleScale = 0.01
        rippleOpacity = 1

        withAnimation(.easeOut(duration: DesignSystemButtonToken.rippleDuration)) {
            rippleScale = 1
            rippleOpacity = 0
        }
    }
}
#endif
