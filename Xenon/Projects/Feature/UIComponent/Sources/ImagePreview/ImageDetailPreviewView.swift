//
//  ImageDetailPreviewView.swift
//  UIComponent
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import Alamofire
import Kingfisher

public struct ImageDetailPreviewView: View {
    
    public init(_ url: URL?, previewURL: URL? = nil, blurHash: String? = nil, height: CGFloat, aspect: Double?) {
        self.url = url
        self.previewURL = previewURL
        self.blurHash = blurHash
        self.height = height
        self.aspect = aspect
    }
    
    private let url: URL?
    private let previewURL: URL?
    private let blurHash: String?
    private let height: CGFloat
    private let aspect: Double?
    public var body: some View {
        Button {
            if let url {
                ImagePreviewManager().showPreview(url: url, previewURL: previewURL)
            }
        } label: {
            KFImage(previewURL ?? url)
                .placeholder({ _ in
                    if let blurHash {
                        let aspectWidth = height * max((aspect ?? 1), 1)
                        BlurHashView(blurHash: blurHash, size: .init(width: aspectWidth, height: height))
                            .frame(width: aspectWidth, height: height)
                    } else {
                        ProgressView()
                    }
                })
                .resizable()
                .scaledToFit()
        }
        .buttonStyle(.plain)
    }
}
