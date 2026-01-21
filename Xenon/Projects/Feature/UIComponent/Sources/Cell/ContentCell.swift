//
//  ContentCell.swift
//  UIComponent
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import EmojiText
import Sugar

public struct ActionButtonContent {
    
    public let id = UUID()
    public let title: String?
    public let image: Image
    
    public let action: () -> Void
    
    public init(title: String?, image: Image, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
    }
}

public struct ContentCell<Header: View, Content: View>: View {
    
    @Namespace private var namespace
    @State var isPresented = false
    public let content: String
    public let date: Date?
    public let buttons: [ActionButtonContent]
    public let emojis: [RemoteEmoji]
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 8) {
                header()
                EmojiText(markdown: content, emojis: emojis)
                    .animated(true)
                    .emojiText.size(24)
                    .font(.styled(.body))
                    .padding(.bottom, 4)
                extraContents()
                actionButtonsView
            }
            .padding(12)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            }
            if let date {
                Text(date, style: .date) // TODO: - Add Format Style
                    .padding(.leading, 8)
                    .padding(.bottom, 4)
            }
        }
    }
    
    @ViewBuilder
    private var actionButtonsView: some View {
        ViewThatFits {
            HStack(spacing: 12) {
                Spacer()
                ForEach(buttons, id: \.id) { button in
                    Button {
                        button.action()
                    } label: {
                        HStack(alignment: .bottom, spacing: 2) {
                            button.image
                                .frame(width: 24)
                            if let title = button.title {
                                Text(title)
                            }
                        }
                    }
                }
            }
            
            HStack(spacing: 12) {
                Spacer()
                ForEach(buttons, id: \.id) { button in
                    Button {
                        button.action()
                    } label: {
                        HStack(alignment: .bottom, spacing: 2) {
                            button.image
                                .frame(width: 24)
                        }
                    }
                }
            }
            
            HStack(spacing: 4) {
                Spacer()
                Menu {
                    ForEach(buttons, id: \.id) { button in
                        Button {
                            button.action()
                        } label: {
                            button.image
                            if let title = button.title {
                                Text(title)
                            }
                        }
                        
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32  , height: 32)
                }
            }
        }
    }
    
    // MARK: - Attribute
    
    private let header: () -> Header
    private let extraContents: () -> Content
    
    // MARK: - Initialization
        
    public init(
        content: String,
        date: Date?,
        buttons: [ActionButtonContent],
        emojis: [RemoteEmoji] = [],
        header: @escaping () -> Header = { EmptyView() },
        extraContents: @escaping () -> Content = { EmptyView() }
    ) {
        self.content = content
        self.date = date
        self.buttons = buttons
        self.emojis = emojis
        self.header = header
        self.extraContents = extraContents
    }
}
