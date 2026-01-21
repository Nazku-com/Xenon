//
//  ImageView.swift
//  xenon
//
//  Created by 김수환 on 12/10/25.
//

import SwiftUI
import Sugar

public struct ImageView: View {
    
    let url: URL?
    var aspectRatio: ContentMode
    @State var isFailed: Bool = false
    @State var image: UIImage?
    
    public var body: some View {
        if isFailed {
            Image(systemName: "xmark")
                .renderingMode(.template)
                .bold()
                .foregroundStyle(.red)
        } else {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: aspectRatio)
            } else {
                ProgressView()
                    .task {
                        guard let url else {
                            isFailed = true
                            return
                        }
                        image = await ImageManager.shared.loadImage(with: url)
                        isFailed = image == nil
                    }
            }
        }
    }
    
    public init(url: URL?, aspectRatio: ContentMode = .fit) {
        self.url = url
        self.aspectRatio = aspectRatio
    }
}
