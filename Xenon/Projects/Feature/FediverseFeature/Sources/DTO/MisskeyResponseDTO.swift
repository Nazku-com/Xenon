//
//  MisskeyResponseDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

public class MisskeyResponseDTO: NetworkingDTOType {
    let id: String
    let createdAt: String
    let userId: String
    let user: MisskeyAccountDTO
    let text: String?
    let cw: String?
    let visibility: String?
    let renoteCount: Int
    let repliesCount: Int
    let reactionCount: Int
    let reactions: [String: Int]
    let emojis: [String: String]?
    let myReaction: String?
    let tags: [String]?
    let fileIds: [String]
    let files: [FileDTO]
    let replyId: String?
    let renote: MisskeyResponseDTO?
    let renoteId: String?
    let uri: String?
    let url: String?
    let clippedCount: Int
    
    struct FileDTO: NetworkingDTOType {
        let id: String
        let createdAt: String
        let name: String
        let type: String // "image/jpeg"
        let size: Int
        let isSensitive: Bool
        let blurhash: String?
        let properties: Properties
        let url: String
        let comment: String?
        let userId: String?
        let user: String?
        
        struct Properties: Codable {
            let width: Int?
            let height: Int?
        }
        
        func toEntity() -> FediverseResponseEntity.Attachment {
            var type: FediverseResponseEntity.Attachment.AttachmentType {
                if let string = self.type.split(separator: "/").first {
                    return FediverseResponseEntity.Attachment.AttachmentType(rawValue: String(string)) ?? .unknown
                } else {
                    return .unknown
                }
            }
            var aspect: CGFloat {
                guard let width = properties.width,
                      let height = properties.height
                else {
                    return 1
                }
                return CGFloat(width / height)
            }
            return .init(
                id: id,
                type: type,
                url: url,
                remoteURL: url,
                previewURL: url,
                description: comment,
                aspect: aspect,
                blurhash: blurhash
            )
        }
    }
    
    public func toEntity() -> FediverseResponseEntity {
        .init(
            id: id,
            uri: uri ?? "",
            url: .init(string: url ?? ""),
            account: user.toEntity(),
            inReplyToID: replyId, // TODO: - 확인 필요
            inReplyToAccountID: nil, // TODO: - 확인 필요
            content: text ?? "",
            createdAt: createdAt,
            emojis: [:], // TODO: -
            reblogsCount: renoteCount,
            favouritesCount: reactionCount,
            reblogged: renoteId != nil, // TODO: - 확인 필요
            favourited: myReaction != nil, // TODO: - 확인 필요
            sensitive: cw != nil,
            spoilerText: cw ?? "",
            visibility: .init(fromRawValue: visibility ?? ""),
            mediaAttachments: files.compactMap({ $0.toEntity() }),
            mentions: [], // TODO: -
            tags: [], // TODO: -
            application: nil, // TODO: -
            language: nil, // TODO: -
            reblog: renote?.toEntity(),
            pinned: false // TODO: -
        )
    }
}

public struct MisskeyAccountDTO: NetworkingDTOType {
    
    public let id: String?
    public let username: String
    public let name: String?
    public let host: String?
    public let avatarUrl: String
    public let avatarBlurhash: String?
    public let description: String?
    public let bannerUrl: String?
    public let bannerBlurhash: String?
    
    public let isLocked: Bool?
    public let emojis: [String: String]
    public let onlineStatus: OnlineStatus?
    public let createdAt: String?
    public let followersCount: Int?
    public let followingCount: Int?
    
    public enum OnlineStatus: String, Codable {
        
        case online
        case active
        case offline
        case unknown
    }
    
    init(
        id: String?,
        username: String,
        name: String?,
        host: String?,
        avatarUrl: String,
        avatarBlurhash: String?,
        description: String?,
        bannerUrl: String?,
        bannerBlurhash: String?,
        isLocked: Bool?,
        emojis: [String : String],
        onlineStatus: OnlineStatus?,
        createdAt: String?,
        followersCount: Int?,
        followingCount: Int?
    ) {
        self.id = id
        self.username = username
        self.name = name
        self.host = host
        self.avatarUrl = avatarUrl
        self.avatarBlurhash = avatarBlurhash
        self.description = description
        self.bannerUrl = bannerUrl
        self.bannerBlurhash = bannerBlurhash
        self.isLocked = isLocked
        self.emojis = emojis
        self.onlineStatus = onlineStatus
        self.createdAt = createdAt
        self.followersCount = followersCount
        self.followingCount = followingCount
    }
    
    public func toEntity() -> FediverseAccountEntity {
        let account: String = {
            if let host {
                return "\(username)@\(host)"
            }
            return username
        }()
        return FediverseAccountEntity(
            id: id ?? "",
            username: username,
            acct: account,
            displayName: name,
            note: description ?? "",
            url: "",
            avatar: avatarUrl,
            avatarBlurhash: avatarBlurhash,
            header: bannerUrl ?? "",
            headerBlurhash: bannerBlurhash,
            locked: isLocked ?? false,
            createdAt: DateFormatter.fediverseFormatter.date(from: createdAt ?? "") ?? Date(),
            followersCount: followersCount ?? 0,
            followingCount: followingCount ?? 0,
            fields: [], // TODO: -
            emojis: emojis.compactMapValues { URL(string: $0) }
        )
    }
}
