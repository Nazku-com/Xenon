//
//  MainHostingViewController.swift
//  xenon
//
//  Created by 김수환 on 12/28/25.
//

import SwiftUI
import Combine
import FediverseFeature
import UIComponent
import SafariServices
import UIKit

final class MainHostingViewController: BaseHostingViewController<MainView> {
    
    var sideBarView: SideBarView?
    
    // MARK: - Attribute
    
    private let dimmViewDidTapPublisher: PassthroughSubject<Void, Never> = .init()
    private lazy var sideBarOpenGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSideBarOpenGesture(_:)))
    private var tappedPoint: CGPoint?
    private let model: MainViewModel
    
    // MARK: - Initialization
    
    init(model: MainViewModel) {
        self.model = model
        super.init(rootView: .init(mainViewModel: model))
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        sideBarOpenGesture.edges = .left
        sideBarOpenGesture.delegate = self
        view.addGestureRecognizer(sideBarOpenGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sideBarView?.updateFrame(view.frame, safeAreaInsets: view.safeAreaInsets)
    }
    
    // MARK: - Bind
    
    override func bind() {
        model.output.receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self else { return }
                switch output {
                case .navigateTo(let viewController, let point):
                    tappedPoint = point
                    navigationController?.pushViewController(viewController, animated: true)
                case .toggleSideBarState:
                    toggleSideBarState()
                case .openURL(let url):
                    openURL(url)
                }
            }.store(in: &cancellables)
        
        dimmViewDidTapPublisher.receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                dismissSideBar()
            }.store(in: &cancellables)
    }
    
    private func openURL(_ url: URL) {
        Task {
            let destination = await checkDestination(url)
            switch destination {
            case .handle(let account):
                return
            case .hashtag(let tag):
                return
            case .url(let url):
                let viewController = FediWebViewController(url: url)
                UIApplication.shared.topViewController?.present(viewController, animated: true)
            }
        }
    }
}

// MARK: - URLHandler

private extension MainHostingViewController {
    
    enum URLType: Hashable {
        
        case handle(account: FediverseAccountEntity)
        case hashtag(tag: String)
        case url(url: URL)
    }
    
    func checkDestination(_ url: URL) async -> URLType {
        let type = await checkURLType(for: url)
        return type
    }
    
    private func checkURLType(for url: URL) async -> URLType {
        if url.pathComponents.contains(where: { $0 == "tags" }),
           let tag = url.pathComponents.last
        {
            return .hashtag(tag: tag)
        }
        if url.lastPathComponent.first == "@",
           let host = url.host() {
            let handle = "\(url.lastPathComponent)@\(host)"
//            if let account = model.currentOAuthData.userInfo(handle: handle) {
//            return .handle(account: account)
//        }
        }
        return .url(url: url)
    }
}

// MARK: - Action

private extension MainHostingViewController {
    
    @objc func handleSideBarOpenGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let progress = gestureRecognizer.translation(in: view).x / SideBarView.Metric.contentViewWidth
        switch gestureRecognizer.state {
        case .began:
            sideBarView = .init(frame: view.frame, safeAreaInsets: view.safeAreaInsets, dimmViewDidTapPublisher: dimmViewDidTapPublisher)
            guard let sideBarView else { return }
            view.superview?.addSubview(sideBarView)
        case .changed:
            sideBarView?.updateProgress(min(progress, 1))
        case .ended:
            if progress > 0.5 {
                UIView.animate(withDuration: 0.2) {
                    self.sideBarView?.updateProgress(1)
                }
            } else {
                dismissSideBar()
            }
        default:
            dismissSideBar()
        }
    }
    
    private func toggleSideBarState() {
        if sideBarView == nil {
            sideBarView = .init(frame: view.frame, safeAreaInsets: view.safeAreaInsets, dimmViewDidTapPublisher: dimmViewDidTapPublisher)
            view.superview?.addSubview(sideBarView!)
            UIView.animate(withDuration: 0.2) {
                self.sideBarView?.updateProgress(1)
            }
        } else {
            dismissSideBar()
        }
    }
    
    private func dismissSideBar() {
        UIView.animate(withDuration: 0.2) {
            self.sideBarView?.updateProgress(.zero)
        } completion: { _ in
            self.sideBarView?.removeFromSuperview()
            self.sideBarView = nil
        }
    }
}

extension MainHostingViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === navigationController?.interactivePopGestureRecognizer {
            return navigationController?.viewControllers.count ?? 0 > 1
        }
        if gestureRecognizer === sideBarOpenGesture {
            return model.isLoggedIn
        }
        return false
    }
}
