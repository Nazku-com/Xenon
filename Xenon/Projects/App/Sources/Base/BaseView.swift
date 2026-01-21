//
//  BaseView.swift
//  xenon
//
//  Created by 김수환 on 12/29/25.
//

import UIKit
import Combine

class BaseView: UIView {
    
    // MARK: - Attribute
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUpAttributes()
        setUpSubviews()
        setUpConstraints()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    // MARK: - Setup
    
    func setUpAttributes() {
        // Override point
    }
    func setUpSubviews() {
        // Override point
    }
    func setUpConstraints() {
        // Override point
    }
    func bind() {
        // Override point
    }
}
