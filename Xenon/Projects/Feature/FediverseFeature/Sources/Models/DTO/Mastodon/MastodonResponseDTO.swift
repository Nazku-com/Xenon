//
//  MastodonResponseDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//


// original source from https://github.com/MastodonKit/MastodonKit

import Foundation
import NetworkingFeature
import Sugar

public final class MastodonResponseDTO: NetworkingDTOType {
    /// The ID of the status.
    public let id: String?
    /// A Fediverse-unique resource ID.
    public let uri: String?
    /// URL to the status page (can be remote).
    public let url: String?
    /// The Account which posted the status.
    public let account: Account?
    /// null or the ID of the status it replies to.
    public let inReplyToID: String?
    /// null or the ID of the account it replies to.
    public let inReplyToAccountID: String?
    /// Body of the status; this will contain HTML (remote HTML already sanitized).
    public let content: String?
    /// The time the status was created.
    public let createdAt: String?
    /// An array of Emoji.
    public let emojis: [Emoji]?
    /// The number of reblogs for the status.
    public let reblogsCount: Int?
    /// The number of favourites for the status.
    public let favouritesCount: Int?
    /// Whether the authenticated user has reblogged the status.
    public let reblogged: Bool?
    /// Whether the authenticated user has favourited the status.
    public let favourited: Bool?
    /// Whether media attachments should be hidden by default.
    public let sensitive: Bool?
    /// If not empty, warning text that should be displayed before the actual content.
    public let spoilerText: String?
    /// The visibility of the status.
    public let visibility: Visibility?
    /// An array of attachments.
    public let mediaAttachments: [Attachment]?
    /// An array of mentions.
    public let mentions: [Mention]?
    /// An array of tags.
    public let tags: [Tag]?
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
    
    public func toEntity() async throws -> FediverseResponseEntity {
        guard let id,
              let uri,
              let url,
              let account = try await account?.toEntity()
        else {
            throw FediverseResponseError.entityParseFailed
        }
        async let content = await content?.parseHTMLToMarkdown() ?? ""
        let emojis = emojis?.toDictionary ?? [:]
        let reblogged = reblogged ?? false
        let favourited = favourited ?? false
        let sensitive = sensitive ?? false
        async let spoilerText = await spoilerText?.parseHTMLToMarkdown() ?? ""
        let visibility = visibility?.toFediverseVisibility ?? .unknwon
        async let mediaAttachments = (try? await mediaAttachments?.toEntity()) ?? []
        async let mentions = (try? await mentions?.toEntity()) ?? []
        async let tags = (try? await tags?.toEntity()) ?? []
        async let application = try? await application?.toEntity()
        async let reblog = try? await reblog?.toEntity()
        let pinned = pinned ?? false
        
        return .init(
            id: id,
            uri: uri,
            url: url,
            account: account,
            inReplyToID: inReplyToID,
            inReplyToAccountID: inReplyToAccountID,
            content: await content,
            createdAt: createdAt ?? "",
            emojis: emojis,
            reblogsCount: reblogsCount ?? 0,
            favouritesCount: favouritesCount ?? 0,
            reblogged: reblogged,
            favourited: favourited,
            sensitive: sensitive,
            spoilerText: await spoilerText,
            visibility: visibility,
            mediaAttachments: await mediaAttachments,
            mentions: await mentions,
            tags: await tags,
            application: await application,
            language: language,
            reblog: await reblog,
            pinned: pinned
        )
    }
}
