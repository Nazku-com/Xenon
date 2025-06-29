//
//  FediverseResponesEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public typealias Emojis = [String: URL]
public final class FediverseResponseEntity: NetworkingEntityType, Identifiable {
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
    public let pinned: Bool?
    
    public enum Visibility: String, Codable {
        /// The status message is public.
        /// - Visible on Profile: Anyone incl. anonymous viewers.
        /// - Visible on Public Timeline: Yes.
        /// - Federates to other instances: Yes.
        case `public`
        /// The status message is unlisted.
        /// - Visible on Profile: Anyone incl. anonymous viewers.
        /// - Visible on Public Timeline: No.
        /// - Federates to other instances: Yes.
        case unlisted
        /// The status message is private.
        /// - Visible on Profile: Followers only.
        /// - Visible on Public Timeline: No.
        /// - Federates to other instances: Only remote @mentions.
        case `private`
        /// The status message is direct.
        /// - Visible on Profile: No.
        /// - Visible on Public Timeline: No.
        /// - Federates to other instances: Only remote @mentions.
        case direct
        
        case unknwon
        
        public init(fromRawValue: String) {
            self = Visibility(rawValue: fromRawValue) ?? .unknwon
        }
    }
    
    public struct  Attachment: NetworkingEntityType, Hashable {
        /// ID of the attachment.
        public let id: String
        /// Type of the attachment.
        public let type: AttachmentType
        /// URL of the locally hosted version of the image.
        public let url: URL?
        /// For remote images, the remote URL of the original image.
        public let remoteURL: URL?
        /// URL of the preview image.
        public let previewURL: URL?
        /// A description of the image for the visually impaired.
        public let description: String?
        /// aspect of attachment
        public let aspect: Double?
        /// blurhash
        public let blurhash: String?
        
        public enum AttachmentType: String, Codable, Hashable {
            /// The attachment contains a static image.
            case image
            /// The attachment contains a video.
            case video
            /// The attachment contains a gif image.
            case gifv
            /// The attachment contains an audio file.
            case audio
            /// The attachment contains an unknown image file.
            case unknown
        }
        
        init(
            id: String,
            type: AttachmentType,
            url: String,
            remoteURL: String?,
            previewURL: String?,
            description: String?,
            aspect: Double?,
            blurhash: String?
        ) {
            self.id = id
            self.type = type
            self.url = .init(string: url)
            self.remoteURL = .init(string: remoteURL ?? "")
            self.previewURL = .init(string: previewURL ?? "")
            self.description = description
            self.aspect = aspect
            self.blurhash = blurhash
        }
    }
    public struct Mention: NetworkingEntityType, Hashable {
        /// Account ID.
        public let id: String
        /// The username of the account.
        public let username: String
        /// Equals username for local users, includes @domain for remote ones.
        public let acct: String
        /// URL of user's profile (can be remote).
        public let url: String
    }
    public struct Tag: NetworkingEntityType, Hashable {
        /// The hashtag, not including the preceding #.
        public let name: String
        /// The URL of the hashtag.
        public let url: String
    }
    
    public struct Application: NetworkingEntityType, Hashable {
        /// Name of the app.
        public let name: String
        /// Homepage URL of the app.
        public let website: String?
    }
    
    
    public init(
        id: String,
        uri: String,
        url: URL?,
        account: FediverseAccountEntity,
        inReplyToID: String?,
        inReplyToAccountID: String?,
        content: String,
        createdAt: String,
        emojis: Emojis,
        reblogsCount: Int,
        favouritesCount: Int,
        reblogged: Bool?,
        favourited: Bool?,
        sensitive: Bool?,
        spoilerText: String,
        visibility: Visibility,
        mediaAttachments: [Attachment],
        mentions: [Mention],
        tags: [Tag],
        application: Application?,
        language: String?,
        reblog: FediverseResponseEntity?,
        pinned: Bool?
    ) {
        self.id = id
        self.uri = uri
        self.url = url
        self.account = account
        self.inReplyToID = inReplyToID
        self.inReplyToAccountID = inReplyToAccountID
        self.content = content
        self.createdAt = DateFormatter.fediverseFormatter.date(from: createdAt) ?? Date()
        self.emojis = emojis
        self.reblogsCount = reblogsCount
        self.favouritesCount = favouritesCount
        self.reblogged = reblogged ?? false
        self.favourited = favourited ?? false
        self.sensitive = sensitive ?? false
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
}
