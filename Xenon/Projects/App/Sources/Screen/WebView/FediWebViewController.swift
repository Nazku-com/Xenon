//
//  FediWebViewController.swift
//  xenon
//
//  Created by 김수환 on 1/11/26.
//

import UIKit
import WebKit
import Combine
import UIComponent
import Sugar

final class FediWebViewController: BaseViewController {
    
    // MARK: - UI
    
    let refreshControl: UIRefreshControl = UIRefreshControl()
    let progressView: UIProgressView = .init()
    private let webView: WKWebView
    
    // MARK: - Attribute
    
    let slideManager = SlideTransitionManager()
    
    // MARK: - Initialization
    
    init(url: URL) {
        webView = .init()
        webView.load(.init(url: url))
        super.init()
        title = url.host() ?? url.absoluteString
        modalPresentationStyle = .fullScreen
        slideManager.apply(to: self)
    }
    
    @MainActor
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "loading")
    }
    
    override func setUpAttributes() {
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .systemBlue
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func setUpSubviews() {
        view.addSubviews([webView, progressView])
        webView.scrollView.addSubview(refreshControl)
    }
    
    override func setUpConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.progressPadding),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Metric.progressPadding),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        } else if keyPath == "loading" {
            progressView.setProgress(webView.isLoading ? 0.1 : 0, animated: true)
        }
    }
    
    override func bind() {
        refreshControl.publisher(for: .valueChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                webView.reload()
                refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
    }
}

extension FediWebViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            progressView.alpha = 1
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self else { return }
            progressView.alpha = 0
        }
    }
    
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse
    ) async -> WKNavigationResponsePolicy {
        guard let url = navigationResponse.response.url else {
            return .allow
        }
        if ((navigationResponse.response as? HTTPURLResponse)?.allHeaderFields["Content-Type"] as? String)?.contains("application/pdf") ?? false {
            
            return .cancel
        }
        return .allow
    }
}

// MARK: - Constant

private extension FediWebViewController {
    
    enum Metric {
        
        static let progressPadding: CGFloat = 64
    }
}
