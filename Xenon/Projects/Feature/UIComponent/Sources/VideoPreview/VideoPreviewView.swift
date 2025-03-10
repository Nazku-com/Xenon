//
//  VideoPreviewView.swift
//  UIComponent
//
//  Created by 김수환 on 3/10/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI

public struct VideoPreviewView: View {
    
    let url: URL?
    let previewURL: URL?
    let blurhash: String?
    let height: CGFloat
    let aspect: Double?
    
    public var body: some View {
        Button {
            if let url {
                VideoPlayManager().playVideo(url: url)
            }
        } label: {
            KFImageView(previewURL, height: height, aspect: aspect)
                .overlay {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white)
                        .shadow(radius: 3)
                }
        }
    }
    
    public init(url: URL?, previewURL: URL?, blurhash: String?, height: CGFloat, aspect: Double?) {
        self.url = url
        self.previewURL = previewURL
        self.blurhash = blurhash
        self.height = height
        self.aspect = aspect
    }
}
