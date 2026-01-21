//
//  WKWebViewWrapper.swift
//  example.UIComponent
//
//  Created by 김수환 on 2/6/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import WebKit

public struct WKWebViewWrapper: UIViewRepresentable {
    
    var url: URL?
    var webView: WKWebView
    
    public init(url: URL? = nil) {
        self.url = url
        self.webView = WKWebView()
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        
        guard let url = url else {
            return webView
        }
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        return
    }
}
