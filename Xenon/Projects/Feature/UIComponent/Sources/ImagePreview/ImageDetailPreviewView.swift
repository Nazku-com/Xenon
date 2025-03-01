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
    
    public init(_ url: URL?, blurHash: String? = nil, height: CGFloat, aspect: Double?) {
        self.url = url
        self.blurHash = blurHash
        self.height = height
        self.aspect = aspect
    }
    
    private let url: URL?
    private let blurHash: String?
    private let height: CGFloat
    private let aspect: Double?
    @State private var image: UIImage?
    public var body: some View {
        if let image {
            Button {
                ImagePreviewManager().showPreview(image: image)
            } label: {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            .buttonStyle(.plain)
        } else {
            let aspectWidth = height * max((aspect ?? 1), 1)
            if url != nil {
                if let blurHash {
                    BlurHashView(blurHash: blurHash, size: .init(width: aspectWidth, height: height))
                        .frame(width: aspectWidth, height: height)
                        .onAppear {
                            loadImage()
                        }
                } else {
                    ProgressView()
                        .onAppear {
                            loadImage()
                        }
                }
            }
        }
    }
    
    private func loadImage() {
        guard let url else { return } // TODO: - Show error
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                image = imageResult.image
            case .failure(let error):
                print("Failed to load image: \(error)")
            }
        }
    }
}
