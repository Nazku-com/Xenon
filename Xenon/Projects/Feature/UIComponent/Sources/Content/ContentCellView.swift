//
//  ContentCellView.swift
//  UIComponent
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import EmojiText
import Kingfisher

public struct ContentCellView<Buttons: View, Content: ContentType>: View {
    
    @State var hideContents: Bool
    @State var content: Content
    var onAvatarTapped: ((Content.Account) -> Void)
    let urls: [URL]
    let contentLineLimit: Int?
    let buttons: Buttons
    
    public var body: some View {
        VStack(alignment: .leading) {
            if !content.content.isEmpty {
                HtmlText(rawHtml: content.content, emojis: content.remoteEmoji, emojiSize: DesignFont.FontSize.normal)
                    .lineLimit(contentLineLimit)
                    .multilineTextAlignment(.leading)
                    .font(DesignFont.Default.light.normal)
                    .padding(.bottom, 8)
            }
            if let reblog = content.reblog {
                reblogContent(content: reblog)
                    .padding(8)
                    .background {
                        NeumorphicBackgroundView()
                    }
                    .scaleEffect(0.98)
            }
            
            mediaAttatchmentView(mediaAttachments: content.mediaAttachments)
                .padding(.bottom, 6)
            HStack {
                Button {
                    onAvatarTapped(content.account)
                } label: {
                    KFImageView(
                        content.account.avatar,
                        blurHash: content.account.avatarBlurhash,
                        height: 32,
                        aspect: 1
                    )
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(.circle)
                }

                HtmlText(rawHtml: content.account.name, emojis: content.account.remoteEmoji, emojiSize: DesignFont.FontSize.extraSmall)
                    .font(DesignFont.Rounded.Medium.extraSmall)
                    .lineLimit(2)
                Spacer()
                
                buttons
                    .frame(height: 40)
            }
            .buttonStyle(.plain)
            DateTimeView(date: content.createdAt)
        }
        .padding(8)
        .background {
            NeumorphicBackgroundView()
        }
        .overlay {
            if hideContents {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .overlay {
                        VStack {
                            Image(systemName: "eye.slash")
                            Text("Sensitive")
                            Text(content.spoilerText)
                            HStack {
                                Spacer()
                                Button {
                                    hideContents.toggle()
                                } label: {
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .overlay {
                                            Text("See")
                                        }
                                        .frame(width: 70, height: 25)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
            }
        }
        .padding(8)
    }
    
    @ViewBuilder
    private func reblogContent(content: Content) -> some View {
        VStack(alignment: .leading) {
            if !content.content.isEmpty {
                HtmlText(rawHtml: content.content, emojis: content.remoteEmoji, emojiSize: DesignFont.FontSize.normal)
                    .lineLimit(contentLineLimit)
                    .multilineTextAlignment(.leading)
                    .font(DesignFont.Default.light.normal)
                    .padding(.bottom, 8)
            }
            mediaAttatchmentView(mediaAttachments: content.mediaAttachments)
            HStack {
                Button {
                    onAvatarTapped(content.account)
                } label: {
                    KFImageView(
                        content.account.avatar,
                        blurHash: content.account.avatarBlurhash,
                        height: 32,
                        aspect: 1
                    )
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .clipShape(.circle)
                }
                HtmlText(rawHtml: content.account.name, emojis: content.account.remoteEmoji, emojiSize: DesignFont.FontSize.extraSmall)
                    .font(DesignFont.Rounded.Medium.extraSmall)
                    .lineLimit(2)
            }
            .buttonStyle(.plain)
            DateTimeView(date: content.createdAt)
        }
    }
    
    @ViewBuilder
    private func mediaAttatchmentView(mediaAttachments: [Content.MediaAttachments]) -> some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 2) {
                ForEach(mediaAttachments, id: \.id) { mediaAttachment in
                    switch mediaAttachment.contentType {
                    case .image:
                        ImageDetailPreviewView(
                            mediaAttachment.url,
                            previewURL: mediaAttachment.previewURL,
                            blurHash: mediaAttachment.blurhash,
                            height: 150,
                            aspect: mediaAttachment.aspect
                        )
                    case .video:
                        VideoPreviewView(
                            url: mediaAttachment.url,
                            previewURL: mediaAttachment.previewURL,
                            blurhash: mediaAttachment.blurhash,
                            height: 150,
                            aspect: mediaAttachment.aspect
                        )
                    case .gifv:
                        if let url = mediaAttachment.url {
                            GifPlayer(url: url, height: 150)
                                .frame(height: 150)
                                .frame(minWidth: 1)
                                .frame(maxWidth: .infinity)
                        }
                    default:
                        Text("Unsupported media attachment type") // TODO: -
                            .padding(16)
                    }
                }
            }
            .frame(height: mediaAttachments.isEmpty ? 0 : 150)
        }
        .scrollTargetBehavior(.paging)
        .scrollIndicators(.hidden)
        .background {
            NeumorphicBackgroundView(isInnerShadowEnabled: true, shape: .rect)
        }
        .border(Color.Neumorphic.main, width: 4)
        .background {
            NeumorphicBackgroundView(shape: .rect)
        }
    }
    
    public init(
        content: Content,
        contentLineLimit: Int? = 5,
        hideContents: Bool,
        buttons: @escaping () -> Buttons,
        onAvatarTapped: @escaping ((Content.Account) -> Void)
    ) {
        self.content = content
        self.contentLineLimit = contentLineLimit
        self.buttons = buttons()
        self.onAvatarTapped = onAvatarTapped
        self.hideContents = hideContents
        
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: content.content, options: [], range: NSRange(location: 0, length: content.content.utf16.count))
        urls = matches?.compactMap({ $0.url }) ?? []
    }
}
