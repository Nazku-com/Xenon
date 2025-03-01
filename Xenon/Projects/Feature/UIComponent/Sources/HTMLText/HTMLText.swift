//
//  HTMLText.swift
//  UIComponent
//
//  Created by 김수환 on 1/31/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import SwiftHTMLtoMarkdown
import EmojiText

public struct HtmlText: View {
    
    let html: String
    let emojis: [RemoteEmoji]
    let emojiSize: CGFloat?
    private let markdownText: String?
    
    
    @State private var nsAttributedString: NSAttributedString?
    
    public var body: some View {
        if let markdownText {
            EmojiText(markdown: markdownText, emojis: emojis)
                .emojiText.size(emojiSize)
        } else {
            failBackView
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
        var document = BasicHTML(rawHTML: rawHtml)
        try? document.parse()
        
        markdownText = try? document.asMarkdown()
    }
}
