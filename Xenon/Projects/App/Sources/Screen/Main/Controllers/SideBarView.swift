//
//  SideBarView.swift
//  xenon
//
//  Created by 김수환 on 12/29/25.
//

import UIKit
import Sugar
import Combine

final class SideBarView: BaseView {
    
    // MARK: - Interface
    
    let dimmViewDidTapPublisher: PassthroughSubject<Void, Never>
    
    func updateFrame(_ frame: CGRect, safeAreaInsets: UIEdgeInsets) {
        self.frame = frame
        contentView.frame.origin.y = safeAreaInsets.top
        contentView.frame.size.height = frame.size.height - safeAreaInsets.top - safeAreaInsets.bottom
        contentView.frame.origin.x += safeAreaInsets.left - superViewSafeAreaInsets.left
        superViewSafeAreaInsets = safeAreaInsets
    }
    
    func updateProgress(_ progress: CGFloat) {
        backgroundView.alpha = min(1 * progress, 1)
        contentView.frame.origin.x =  Double(-Metric.contentViewWidth) + Double(Metric.contentViewWidth) * progress + 8 + superViewSafeAreaInsets.left
    }
    
    init(frame: CGRect, safeAreaInsets: UIEdgeInsets, dimmViewDidTapPublisher: PassthroughSubject<Void, Never>) {
        self.superViewSafeAreaInsets = safeAreaInsets
        self.dimmViewDidTapPublisher = dimmViewDidTapPublisher
        super.init(frame: frame)
    }
    
    // MARK: - UI
    
    private let contentView: UIVisualEffectView = {
        if #available(iOS 26.0, *) {
            let glassEffect = UIGlassEffect(style: .clear)
            glassEffect.tintColor = .black.withAlphaComponent(0.2)
            return UIVisualEffectView(effect: glassEffect)
        } else {
            return UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        }
    }()
    private let backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    // MARK: - Attribute
    
    private var superViewSafeAreaInsets: UIEdgeInsets
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
    
    // MARK: - Setup
    
    override func setUpAttributes() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 24
        addGestureRecognizer(tapGesture)
        backgroundView.alpha = 0
    }
    
    override func setUpSubviews() {
        addSubviews([
            backgroundView,
            contentView
        ])
    }
    
    override func setUpConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        contentView.frame = .init(
            origin: .init(x: -Metric.contentViewWidth, y: superViewSafeAreaInsets.top),
            size: .init(width: Metric.contentViewWidth, height: frame.size.height - superViewSafeAreaInsets.top - superViewSafeAreaInsets.bottom)
        )
    }
}

// MARK: - Action

private extension SideBarView {
    
    @objc func didTap() {
        dimmViewDidTapPublisher.send()
    }
}

// MARK: - Constant

extension SideBarView {
    
    enum Metric {
        
        static let contentViewWidth: CGFloat = 300
    }
}
