//
//  MastodonStatusDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

// original source from https://github.com/MastodonKit/MastodonKit

import Foundation
import Alamofire
import NetworkingFeature

public class MastodonResponseDTO: NetworkingDTOType {
    /// The ID of the status.
    public let id: String
    /// A Fediverse-unique resource ID.
    public let uri: String
    /// URL to the status page (can be remote).
    public let url: String?
    /// The Account which posted the status.
    public let account: Account
    /// null or the ID of the status it replies to.
    public let inReplyToID: String?
    /// null or the ID of the account it replies to.
    public let inReplyToAccountID: String?
    /// Body of the status; this will contain HTML (remote HTML already sanitized).
    public let content: String
    /// The time the status was created.
    public let createdAt: String
    /// An array of Emoji.
    public let emojis: [Emoji]
    /// The number of reblogs for the status.
    public let reblogsCount: Int
    /// The number of favourites for the status.
    public let favouritesCount: Int
    /// Whether the authenticated user has reblogged the status.
    public let reblogged: Bool?
    /// Whether the authenticated user has favourited the status.
    public let favourited: Bool?
    /// Whether media attachments should be hidden by default.
    public let sensitive: Bool?
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
    public let reblog: MastodonResponseDTO?
    /// Whether this is the pinned status for the account that posted it.
    public let pinned: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case uri
        case url
        case account
        case inReplyToID = "in_reply_to_id"
        case inReplyToAccountID = "in_reply_to_account_id"
        case content
        case createdAt = "created_at"
        case emojis
        case reblogsCount = "reblogs_count"
        case favouritesCount = "favourites_count"
        case reblogged
        case favourited
        case sensitive
        case spoilerText = "spoiler_text"
        case visibility
        case mediaAttachments = "media_attachments"
        case mentions
        case tags
        case application
        case language
        case reblog
        case pinned
    }
    
    public class Account: NetworkingDTOType {
        
        public let id: String
        public let username: String
        public let acct: String
        public let displayName: String
        public let note: String
        public let url: String
        public let avatar: String
        public let avatarStatic: String
        public let header: String
        public let headerStatic: String
        public let locked: Bool
        public let createdAt: String
        public let followersCount: Int
        public let followingCount: Int
        public let statusesCount: Int
        public let fields: [Field]?
        public let emojis: [Emoji]?
        
        private enum CodingKeys: String, CodingKey {
            case id
            case username
            case acct
            case displayName = "display_name"
            case note
            case url
            case avatar
            case avatarStatic = "avatar_static"
            case header
            case headerStatic = "header_static"
            case locked
            case createdAt = "created_at"
            case followersCount = "followers_count"
            case followingCount = "following_count"
            case statusesCount = "statuses_count"
            case fields
            case emojis
        }
        
        public func toEntity() -> FediverseAccountEntity {
            let emojiDictionary: [String: URL] = {
                guard let emojis else {
                    return [:]
                }
                return Dictionary(
                    uniqueKeysWithValues: emojis.map { ($0.shortcode, $0.url) }
                )
            }()
            return .init(
                id: id,
                username: username,
                acct: acct,
                displayName: displayName,
                note: note,
                url: url,
                avatar: avatar,
                avatarBlurhash: nil,
                header: header,
                headerBlurhash: nil,
                locked: locked,
                createdAt: DateFormatter.fediverseFormatter.date(from: createdAt) ?? Date(),
                followersCount: followersCount,
                followingCount: followingCount,
                statusesCount: statusesCount,
                fields: fields?.compactMap({ $0.toEntity() }) ?? [],
                emojis: emojiDictionary
            )
        }
    }
    
    public class Field: NetworkingDTOType {
        
        let name: String?
        let value: String?
        let verifiedAt: String?
        
        private enum CodingKeys: String, CodingKey {
            case name
            case value
            case verifiedAt = "verified_at"
        }
        
        public func toEntity() -> FediverseAccountEntity.Field {
            var date: Date? {
                guard let verifiedAt else {
                    return nil
                }
                return DateFormatter.fediverseFormatter.date(from: verifiedAt)
            }
            return .init(
                name: name ?? "",
                value: value ?? "",
                verifiedAt: date
            )
        }
    }

    
    public class Emoji: Codable {
        /// The shortcode of the emoji
        public let shortcode: String
        /// URL to the emoji static image
        public let staticURL: URL
        /// URL to the emoji image
        public let url: URL
        
        private enum CodingKeys: String, CodingKey {
            case shortcode
            case staticURL = "static_url"
            case url
        }
    }
    
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
    }
    
    public struct  Attachment: NetworkingDTOType, Hashable {
        /// ID of the attachment.
        public let id: String
        /// Type of the attachment.
        public let type: AttachmentType
        /// URL of the locally hosted version of the image.
        public let url: String
        /// For remote images, the remote URL of the original image.
        public let remoteURL: String?
        /// URL of the preview image.
        public let previewURL: String?
        /// A description of the image for the visually impaired.
        public let description: String?
        /// A free-form object that might contain information about the attachment.
        public let meta: Meta?
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
        
        public struct Meta: Codable, Hashable {
            
            public let original: Info?
            
            public struct Info: Codable, Hashable {
                public let aspect: Double?
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case id
            case type
            case url
            case remoteURL = "remote_url"
            case previewURL = "preview_url"
            case description
            case blurhash
            case meta
        }
        
        public func toEntity() -> FediverseResponseEntity.Attachment {
            .init(
                id: id,
                type: .init(rawValue: type.rawValue) ?? .unknown,
                url: url,
                remoteURL: remoteURL,
                previewURL: previewURL,
                description: description,
                aspect: meta?.original?.aspect,
                blurhash: blurhash
            )
        }
    }
    
    public struct Mention: Codable, Hashable {
        /// Account ID.
        public let id: String
        /// The username of the account.
        public let username: String
        /// Equals username for local users, includes @domain for remote ones.
        public let acct: String
        /// URL of user's profile (can be remote).
        public let url: String
    }
    
    public struct Tag: Codable, Hashable {
        /// The hashtag, not including the preceding #.
        public let name: String
        /// The URL of the hashtag.
        public let url: String
    }
    
    public struct Application: Codable, Hashable {
        /// Name of the app.
        public let name: String
        /// Homepage URL of the app.
        public let website: String?
    }
    
    public func toEntity() -> FediverseResponseEntity {
        .init(
            id: id,
            uri: uri,
            url: .init(string: url ?? ""),
            account: account.toEntity(),
            inReplyToID: inReplyToID,
            inReplyToAccountID: inReplyToAccountID,
            content: content,
            createdAt: createdAt,
            emojis: Dictionary(
                uniqueKeysWithValues: emojis.map { ($0.shortcode, $0.url) }
            ),
            reblogsCount: reblogsCount,
            favouritesCount: favouritesCount,
            reblogged: reblogged,
            favourited: favourited,
            sensitive: sensitive,
            spoilerText: spoilerText,
            visibility: .init(rawValue: visibility.rawValue) ?? .unlisted,
            mediaAttachments: mediaAttachments.compactMap({ $0.toEntity() }),
            mentions: [], // TODO: -
            tags: [], // TODO: -
            application: .init(name: application?.name ?? "", website: application?.website),
            language: language,
            reblog: reblog?.toEntity(),
            pinned: pinned
        )
    }
}
