//
//  SceneDelegate.swift
//  xenon
//
//  Created by 김수환 on 12/27/25.
//

import UIKit
import Combine
import FediverseFeature
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var mainViewModel: MainViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        mainViewModel = MainViewModel()
        let rootViewController = viewController(for: mainViewModel)
        window.rootViewController = rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func viewController(for model: MainViewModel?) -> UIViewController {
        if let model,
           model.isLoggedIn {
            return UINavigationController(rootViewController: MainHostingViewController(model: model))
        }
        let loginView = LoginView()
        bind(loginPublisher: loginView.model.loginPublisher)
        return UIHostingController(rootView: loginView)
    }
    
    private func bind(loginPublisher: PassthroughSubject<OauthData, Never>) {
        loginPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] oAuthData in
                guard let self else { return }
                mainViewModel?.logIn(with: oAuthData)
                window?.rootViewController = viewController(for: mainViewModel)
            }
            .store(in: &cancellables)
    }
}
