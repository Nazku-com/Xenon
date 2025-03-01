//
//  BlurHashView.swift
//  UIComponent
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

struct BlurHashView: View {
    
    let blurHash: String
    let size: CGSize
    @State private var blurHashedImage: UIImage?
    var body: some View {
        VStack {
            if let blurHashedImage {
                Image(uiImage: blurHashedImage)
            }
        }.task {
            if let blurhash = BlurHash(string: blurHash) {
                if let cgImage = await blurhash.cgImage(size: size) {
                    self.blurHashedImage = UIImage(cgImage: cgImage)
                }
            }
        }
    }
    
    init(blurHash: String, size: CGSize) {
        self.blurHash = blurHash
        self.size = size
    }
}

#Preview {
    BlurHashView(blurHash: "L38E0:Rjt9ob_4RjoMj[RiogRi00", size: .init(width: 300, height: 200))
}
