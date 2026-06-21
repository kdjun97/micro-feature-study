//
//  CustomAlert.swift
//  UIKitPlayGround
//
//  Created by 김동준 on 12/19/25
//

import UIKit
import SnapKit

public class CustomAlert: UIView {
    public weak var delegate: CustomAlertDelegate?

    private let title: String
    private let contents: String
    private let primaryButtonTitle: String
    private let secondaryButtonTitle: String?
    private let isDismissable: Bool
    
    public init(
        title: String,
        contents: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil,
        isDismissable: Bool = false
    ) {
        self.title = title
        self.contents = contents
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.isDismissable = isDismissable
        super.init(frame: .zero)
        setupSubView()
        setupLayout()
        setupAction()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        
        return view
    }()
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .uBlack
        label.numberOfLines = 1
        label.text = self.title
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .uBlack
        label.numberOfLines = 3
        label.text = self.contents
        label.textAlignment = .center

        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = secondaryButtonTitle == nil ? .vertical : .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = secondaryButtonTitle == nil ? 0 : 16
        
        return stackView
    }()
    
    private lazy var primaryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var title = AttributedString(primaryButtonTitle)
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        config.attributedTitle = title
        config.baseBackgroundColor = secondaryButtonTitle == nil ? .main : .gray1
        config.baseForegroundColor = secondaryButtonTitle == nil ? .white : .gray5
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)

        return UIButton(configuration: config)
    }()
    
    private lazy var secondaryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        var title = AttributedString(secondaryButtonTitle ?? "")
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        config.attributedTitle = title
        config.baseBackgroundColor = .main
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)

        return UIButton(configuration: config)
    }()
}

private extension CustomAlert {
    func setupSubView() {
        addSubview(dimmedView)
        addSubview(container)
        
        container.addSubview(titleLabel)
        container.addSubview(contentsLabel)
        container.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(primaryButton)
        
        if let _ = secondaryButtonTitle {
            buttonStackView.addArrangedSubview(secondaryButton)
        }
    }
    
    func setupLayout() {
        dimmedView.snp.makeConstraints {
            $0.top.bottom.trailing.leading.equalToSuperview()
        }
        
        container.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        contentsLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(contentsLabel.snp.bottom).offset(16)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

private extension CustomAlert {
    func setupAction() {
        primaryButton.addTarget(self, action: #selector(primaryAction), for: .touchUpInside)
        if let _ = secondaryButtonTitle {
            secondaryButton.addTarget(self, action: #selector(secondaryAction), for: .touchUpInside)
        }
        if isDismissable {
            let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
            dimmedView.addGestureRecognizer(tap)
        }
    }

    @objc func primaryAction() {
        delegate?.alertDidTapPrimary(self)
        dismiss()
    }
    
    @objc func secondaryAction() {
        delegate?.alertDidTapSecondary(self)
        dismiss()
    }
    
    @objc func backgroundTapped() {
        dismiss()
    }
    
    func dismiss() {
        removeFromSuperview()
        delegate?.alertDidDismiss(self)
    }
}

public protocol CustomAlertDelegate: AnyObject {
    func alertDidTapPrimary(_ alert: CustomAlert)
    func alertDidTapSecondary(_ alert: CustomAlert)
    func alertDidDismiss(_ alert: CustomAlert)
}
