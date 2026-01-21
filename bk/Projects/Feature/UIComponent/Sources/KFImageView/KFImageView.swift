//
//  KFImageView.swift
//  UIComponent
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import Kingfisher

public struct KFImageView: View { // TODO: - 뭔가 하자 있음
    
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
        imageView
            .onAppear {
                loadImage()
            }
    }
    
    @ViewBuilder
    private var imageView: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        } else {
            if url != nil {
                loadingView
            }
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        let aspectWidth: CGFloat = {
            guard let aspect else {
                return height
            }
            return height * max((aspect), 1)
        }()
        if let blurHash {
            BlurHashView(blurHash: blurHash, size: .init(width: aspectWidth, height: height))
                .frame(width: aspectWidth, height: height)
        } else {
            Image(systemName: "circle.dotted")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 25, maxHeight: 25)
                .foregroundStyle(.primary)
                .symbolEffect(.pulse, value: image == nil)
        }
    }
    
    private func loadImage() {
        guard let url else { return } // TODO: - Show error
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let imageResult):
                Task { @MainActor in
                    image = imageResult.image
                }
            case .failure(let error):
                print("Failed to load image: \(error)")
            }
        }
    }
}
