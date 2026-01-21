//
//  URLsPreviewView.swift
//  UIComponent
//
//  Created by 김수환 on 1/31/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

struct URLsPreviewView: View {
    let urls = [
        URL(string: "https://hollo.social/tags/%E5%9C%8B%E6%BC%A2%E6%96%87%E6%B7%B7%E7%94%A8%E9%AB%94")!,
        URL(string: "https://hollo.social/@fedify")!,
        URL(string: "https://botkit.fedify.dev/")!,
    ]
    @State var fetch = false
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(urls, id: \.absoluteString) { url in
                    URLPreviewRepresentable(fetch: $fetch, previewURL: url)
                        .frame(width: 200, height: 80)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    URLsPreviewView()
}
