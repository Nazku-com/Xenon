//
//  AppDelegate.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static private(set) var instance: AppDelegate! = nil

    var loadingViewController: UIViewController?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        AppDelegate.instance = self
        return true
    }
    
    func showLoading(_ show: Bool) {
        guard let rootViewController = UIApplication.shared.firstKeyWindow?.rootViewController else { return }
        
        if show {
            loadingViewController = UIViewController()
            guard let loadingViewController else { return }
            loadingViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            
            let rectangle = UIView()
            rectangle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            rectangle.layer.cornerRadius = 16
            rectangle.frame.size = .init(width: 120, height: 120)
            rectangle.center = loadingViewController.view.center

            loadingViewController.view.addSubview(rectangle)
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.center = loadingViewController.view.center
            spinner.startAnimating()
            loadingViewController.view.addSubview(spinner)
            loadingViewController.modalPresentationStyle = .overFullScreen
            rootViewController.present(loadingViewController, animated: false)
        } else {
            loadingViewController?.dismiss(animated: false)
        }
    }
}
