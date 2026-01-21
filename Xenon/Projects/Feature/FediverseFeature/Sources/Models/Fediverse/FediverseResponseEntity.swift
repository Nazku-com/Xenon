//
//  FediverseResponseEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public typealias Emojis = [String: URL]

public final class FediverseResponseEntity: NetworkingEntityType, Identifiable, Equatable, Hashable {
    
    public static func == (lhs: FediverseResponseEntity, rhs: FediverseResponseEntity) -> Bool { // TODO: -
        lhs.id == rhs.id &&
        lhs.uri == rhs.uri &&
        lhs.url == rhs.url &&
        lhs.account == rhs.account &&
        lhs.inReplyToID == rhs.inReplyToID &&
        lhs.inReplyToAccountID == rhs.inReplyToAccountID &&
        lhs.content == rhs.content &&
        lhs.createdAt == rhs.createdAt &&
        lhs.reblogsCount == rhs.reblogsCount &&
        lhs.favouritesCount == rhs.favouritesCount &&
        lhs.reblogged == rhs.reblogged &&
        lhs.favourited == rhs.favourited &&
        lhs.sensitive == rhs.sensitive &&
        lhs.spoilerText == rhs.spoilerText &&
        lhs.visibility == rhs.visibility &&
        lhs.mediaAttachments == rhs.mediaAttachments &&
        lhs.mentions == rhs.mentions &&
        lhs.tags == rhs.tags &&
        lhs.application == rhs.application &&
        lhs.language == rhs.language &&
        lhs.reblog == rhs.reblog &&
        lhs.pinned == rhs.pinned
    }
    
    var identifier: String {
        return UUID().uuidString
    }
    
    public func hash(into hasher: inout Hasher) { // TODO: -
        return hasher.combine(identifier)
    }
    
    /// The ID of the status.
    public let id: String
    /// A Fediverse-unique resource ID.
    public let uri: String
    /// URL to the status page (can be remote).
    public let url: URL?
    /// The Account which posted the status.
    public let account: FediverseAccountEntity
    /// null or the ID of the status it replies to.
    public let inReplyToID: String?
    /// null or the ID of the account it replies to.
    public let inReplyToAccountID: String?
    /// Body of the status; this will contain HTML (remote HTML already sanitized).
    public let content: String
    /// parsed URLs from content
    public let attachedURLs: [URL]
    /// The time the status was created.
    public let createdAt: Date
    /// An array of Emoji.
    public let emojis: Emojis
    /// The number of reblogs for the status.
    public var reblogsCount: Int
    /// The number of favourites for the status.
    public let favouritesCount: Int
    /// Whether the authenticated user has reblogged the status.
    public var reblogged: Bool
    /// Whether the authenticated user has favourited the status.
    public var favourited: Bool
    /// Whether media attachments should be hidden by default.
    public let sensitive: Bool
    /// If not empty, warning text that should be displayed before the actual content.
    public let spoilerText: String
    /// The visibility of the status.
    public let visibility: Visibility
    /// An array of attachments.
    public let mediaAttachments: [Attachment]
    /// An array of mentions.
    public let mentions: [Mention]
    /// An array of tags.
    public let tags: [Tag]
    /// Application from which the status was posted.
    public let application: Application?
    /// The detected language for the status.
    public let language: String?
    /// The reblogged Status
    public let reblog: FediverseResponseEntity?
    /// Whether this is the pinned status for the account that posted it.
    public let pinned: Bool
    
    public init(
        id: String,
        uri: String,
        url: String,
        account: FediverseAccountEntity,
        inReplyToID: String?,
        inReplyToAccountID: String?,
        content: String,
        createdAt: String,
        emojis: Emojis,
        reblogsCount: Int,
        favouritesCount: Int,
        reblogged: Bool,
        favourited: Bool,
        sensitive: Bool,
        spoilerText: String,
        visibility: Visibility,
        mediaAttachments: [Attachment],
        mentions: [Mention],
        tags: [Tag],
        application: Application?,
        language: String?,
        reblog: FediverseResponseEntity?,
        pinned: Bool
    ) {
        self.id = id
        self.uri = uri
        self.url = URL(string: url)
        self.account = account
        self.inReplyToID = inReplyToID
        self.inReplyToAccountID = inReplyToAccountID
        self.content = content
        self.attachedURLs = Self.extractURLs(from: content) // TODO: - Use Card
        self.createdAt = DateFormatter.fediverseFormatter.date(from: createdAt) ?? Date()
        self.emojis = emojis
        self.reblogsCount = reblogsCount
        self.favouritesCount = favouritesCount
        self.reblogged = reblogged
        self.favourited = favourited
        self.sensitive = sensitive
        self.spoilerText = spoilerText
        self.visibility = visibility
        self.mediaAttachments = mediaAttachments
        self.mentions = mentions
        self.tags = tags
        self.application = application
        self.language = language
        self.reblog = reblog
        self.pinned = pinned
    }
    
    static func extractURLs(from text: String) -> [URL] {
        guard let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue
        ) else { return [] }
        
        let range = NSRange(text.startIndex..., in: text)
        
        return Array(Set(detector.matches(in: text, options: [], range: range)
            .compactMap({ $0.url })
            .filter({ !$0.pathComponents.contains(where: { $0 == "tags" }) }) // filter tag
            .filter({ $0.lastPathComponent.first != "@" }) // filer handle
        ))
    }
}

//    public extension FediverseResponseEntity {
//        
//        struct Card: NetworkingEntityType, Hashable, Equatable {
//            let url: String
//            let title: String
//            let description: String
//            let type: String
//            let author_name: String
//            let author_url: String
//            let provider_name: String
//            let provider_url: String
//            let html: String
//            let width: CGFloat
//            let height: CGFloat
//            let image: String
//            let embed_url: String
//            let blurhash: String
//        }
//    }
