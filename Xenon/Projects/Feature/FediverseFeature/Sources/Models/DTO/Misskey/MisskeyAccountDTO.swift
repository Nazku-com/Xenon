//
//  MisskeyAccountDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public struct MisskeyAccountDTO: NetworkingDTOType {
    
    public let id: String?
    public let username: String?
    public let name: String?
    public let host: String?
    public let avatarUrl: String?
    public let avatarBlurhash: String?
    public let description: String?
    public let bannerUrl: String?
    public let bannerBlurhash: String?
    
    public let isLocked: Bool?
    public let fields: [Fields]?
    public let emojis: [String: String]?
    public let onlineStatus: OnlineStatus?
    public let createdAt: String?
    public let followersCount: Int?
    public let followingCount: Int?
    
    public struct Fields: NetworkingDTOType {
        let name: String
        let value: String
        
        public func toEntity() async throws -> FediverseAccountEntity.Field {
            .init(name: name, value: value, verifiedAt: nil)
        }
    }
    
    public enum OnlineStatus: String, Codable, Sendable {
        
        case online
        case active
        case offline
        case unknown
    }
    
    public func toEntity() async throws -> FediverseAccountEntity {
        guard let id,
              let username
        else {
            throw FediverseResponseError.entityParseFailed
        }
        let account: String = {
            if let host {
                return "\(username)@\(host)"
            }
            return username
        }()
        async let description = await description?.parseHTMLToMarkdown()
        async let fields = try? await fields?.toEntity()
        return FediverseAccountEntity(
            id: id,
            username: username,
            acct: account,
            displayName: await name?.parseHTMLToMarkdown(),
            note: await description ?? "",
            url: "",
            avatar: avatarUrl ?? "",
            avatarBlurhash: avatarBlurhash,
            header: bannerUrl ?? "",
            headerBlurhash: bannerBlurhash,
            locked: isLocked ?? false,
            createdAt: DateFormatter.fediverseFormatter.date(from: createdAt ?? "") ?? Date(),
            followersCount: followersCount ?? 0,
            followingCount: followingCount ?? 0,
            fields: await fields ?? [],
            emojis: emojis?.compactMapValues { URL(string: $0) } ?? [:]
        )
    }
}
