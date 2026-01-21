//
//  BaseViewController.swift
//  xenon
//
//  Created by 김수환 on 1/11/26.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    // MARK: - Attribute

    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
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
    
    // MARK: - Alert
    
    func showAlert(title: String, message: String) {
        let viewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.addAction(.init(title: "네", style: .default))
        present(viewController, animated: true)
    }
}
