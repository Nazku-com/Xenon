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

            
            let blurEffect = UIBlurEffect(style: .systemThinMaterial)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.frame.size = .init(width: 120, height: 120)
            visualEffectView.center = loadingViewController.view.center
            visualEffectView.layer.cornerRadius = 24
            visualEffectView.clipsToBounds = true
            loadingViewController.view.addSubview(visualEffectView)
            
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
