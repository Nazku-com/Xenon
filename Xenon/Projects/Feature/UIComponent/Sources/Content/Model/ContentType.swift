//
//  ContentType.swift
//  UIComponent
//
//  Created by 김수환 on 1/29/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import EmojiText

public protocol ContentType {
    
    associatedtype Account: AccountType
    associatedtype MediaAttachments: MediaAttachmentType
    
    var id: String { get }
    var content: String { get }
    var remoteEmoji: [RemoteEmoji] { get }
    var favourited: Bool { get }
    var account: Account { get }
    var sensitive: Bool { get }
    var spoilerText: String { get }
    var createdAt: Date { get }
    var reblog: Self? { get }
    var mediaAttachments: [MediaAttachments] { get }
}

public protocol MediaAttachmentType {
    
    var id: String { get }
    var contentType: MediaContentType { get }
    var previewURL: URL? { get }
    var blurhash: String? { get }
    var aspect: Double? { get }
}

public protocol AccountType {
    
    var avatar: URL? { get }
    var avatarBlurhash: String? { get }
    var name: String { get }
    var remoteEmoji: [RemoteEmoji] { get }
}

public enum MediaContentType: String, Codable, Hashable {
    
    case image
    case video
    case gifv
    case audio
    case unknown
    
    public init?(string: String) {
        self.init(rawValue: string)
    }
}
