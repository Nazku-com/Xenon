//
//  URLPreview.swift
//  UIComponent
//
//  Created by 김수환 on 1/31/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import LinkPresentation

public class URLPreview: LPLinkView {
    public override var intrinsicContentSize: CGSize { CGSize(width: 0, height: super.intrinsicContentSize.height) }
}

public struct URLPreviewRepresentable: UIViewRepresentable {
    
    @Binding var fetch: Bool
    public typealias UIViewType = URLPreview
    
    public var previewURL: URL
    
    public func makeUIView(context: Context) -> URLPreview {
        let view = URLPreview(url: previewURL)
        let provider = LPMetadataProvider()
        provider.startFetchingMetadata(for: previewURL) { metadata, error in
            if let md = metadata {
                DispatchQueue.main.async {
                    view.metadata = md
                    view.sizeToFit()
                    self.fetch.toggle()
                }
            } else if error != nil {
                let md = LPLinkMetadata()
                md.title = "Error"
                view.metadata = md
                view.sizeToFit()
                self.fetch.toggle()
            }
        }
        return view
    }
    
    public func updateUIView(_ uiView: URLPreview, context: Context) {
    }
}
