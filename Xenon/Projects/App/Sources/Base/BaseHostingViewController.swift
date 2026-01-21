//
//  BaseHostingViewController.swift
//  xenon
//
//  Created by 김수환 on 12/27/25.
//

import SwiftUI
import Combine
import UIKit

class BaseHostingViewController<V: View>: UIHostingController<V> {
    
    // MARK: - Attribute
    
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - View Lifecycle
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpAttributes()
        setUpSubviews()
        setUpConstraints()
        bind()
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
