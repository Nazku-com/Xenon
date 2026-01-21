//
//  Account.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO {
    
    final class Account: NetworkingDTOType {
        
        public let id: String?
        public let username: String?
        public let acct: String?
        public let displayName: String?
        public let note: String?
        public let url: String?
        public let avatar: String?
        public let avatarStatic: String?
        public let header: String?
        public let headerStatic: String?
        public let locked: Bool?
        public let createdAt: String?
        public let followersCount: Int?
        public let followingCount: Int?
        public let statusesCount: Int?
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
        
        public func toEntity() async throws -> FediverseAccountEntity {
            guard let id,
                  let acct
            else {
                throw FediverseResponseError.entityParseFailed
            }
            let emojiDictionary: [String: URL] = {
                guard let emojis else {
                    return [:]
                }
                return Dictionary(
                    uniqueKeysWithValues: emojis.map { ($0.shortcode, $0.url) }
                )
            }()
            async let username = await username?.parseHTMLToMarkdown()
            async let displayName = await displayName?.parseHTMLToMarkdown()
            async let note = await note?.parseHTMLToMarkdown()
            async let fields = try? await fields?.toEntity()
            return .init(
                id: id,
                username: await username,
                acct: acct,
                displayName: await displayName,
                note: await note ?? "",
                url: url ?? "",
                avatar: avatar ?? "",
                avatarBlurhash: nil,
                header: header ?? "",
                headerBlurhash: nil,
                locked: locked ?? true,
                createdAt: DateFormatter.fediverseFormatter.date(from: createdAt ?? "") ?? Date(),
                followersCount: followersCount ?? 0,
                followingCount: followingCount ?? 0,
                statusesCount: statusesCount,
                fields: await fields ?? [],
                emojis: emojiDictionary
            )
        }
    }
}
