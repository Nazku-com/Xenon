//
//  HTMLText.swift
//  UIComponent
//
//  Created by 김수환 on 1/31/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import NetworkingFeature
import SwiftHTMLtoMarkdown
import EmojiText

public struct HtmlText: View {
    
    let html: String
    let emojis: [RemoteEmoji]
    let emojiSize: CGFloat?
    
    @State private var markdownText: String?
    @State private var nsAttributedString: NSAttributedString?
    
    public var body: some View {
        if let markdownText {
            EmojiText(markdown: markdownText, emojis: emojis)
                .emojiText.size(emojiSize)
        } else {
            failBackView
                .task {
                    htmlToMarkDown()
                }
        }
    }
    
    @ViewBuilder
    var failBackView: some View {
        if let nsAttributedString,
           let attributedString = try? AttributedString(nsAttributedString, including: \.swiftUI) {
            Text(attributedString)
        } else {
            Text(html)
                .task {
                    nsAttributedString = html.parseHTML()
                }
        }
    }
    
    public init(rawHtml: String, emojis: [RemoteEmoji] = [], emojiSize: CGFloat? = nil) {
        self.html = rawHtml
        self.emojis = emojis
        self.emojiSize = emojiSize
    }
    private func htmlToMarkDown() {
        Task { @MainActor in
            let markdownText = await parseHTML()
            self.markdownText = markdownText
        }
    }
    
    @BackgroundActor
    private func parseHTML() async -> String? {
        var document = BasicHTML(rawHTML: html)
        try? document.parse()
        return try? document.asMarkdown()
    }
}
