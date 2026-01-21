//
//  Notifications.swift
//  FediverseFeature
//
//  Created by 김수환 on 12/14/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import NetworkingFeature

public extension OauthData {
    
    func notifications(pagenationURL: URL? = nil) async -> Result<(data: [FediverseNotificationEntity], urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            guard let pagenationURL else {
                let response = await NetworkingService().request(
                    api: MastodonAPI.notifications(from: url, token: token),
                    dtoType: [MastodonNotificationDTO].self
                )
                switch response {
                case .success(let success):
                    return .success(success)
                case .failure(let failure):
                    return .failure(failure)
                }
            }
            let response = await NetworkingService().request(
                api: MastodonAPI.get(from: pagenationURL, token: token),
                dtoType: [MastodonNotificationDTO].self
            )
            switch response {
            case .success(let success):
                return .success(success)
            case .failure(let failure):
                return .failure(failure)
            }
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }
}

struct MastodonNotificationDTO: NetworkingDTOType {
    let id: String
    var type: String
    let account: MastodonResponseDTO.Account?
    let status: MastodonResponseDTO?
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case account
        case status
        case createdAt = "created_at"
    }
    
    func toEntity() async -> FediverseNotificationEntity {
        .init(
            id: id,
            type: .init(fromRawValue: type),
            account: try? await account?.toEntity(),
            status: try? await status?.toEntity(),
            createdAt: DateFormatter.fediverseFormatter.date(from: createdAt) ?? Date()
        )
    }
}

public struct FediverseNotificationEntity: NetworkingEntityType, Identifiable {
    
    public let id: String
    public var type: NotificationType
    public let account: FediverseAccountEntity?
    public let status: FediverseResponseEntity?
    public let createdAt: Date
    
    public enum NotificationType: String, Codable {
        /// Someone mentioned you in their status
        case mention
        /// Someone you enabled notifications for has posted a status
        case status
        /// Someone boosted one of your statuses
        case reblog
        /// Someone followed you
        case follow
        /// Someone requested to follow you
        case follow_request
        /// Someone favourited one of your statuses
        case favourite
        /// A poll you have voted in or created has ended
        case poll
        /// A status you boosted with has been edited
        case update
        /// Someone signed up (optionally sent to admins)
        case admin_sign_up
        /// A new report has been filed
        case admin_report
        
        /// unknownType
        case unknown
        
        public init(fromRawValue: String) {
            self = NotificationType(rawValue: fromRawValue) ?? .unknown
        }
        
        private enum CodingKeys: String, CodingKey {
            case mention
            case status
            case reblog
            case follow
            case follow_request
            case favourite
            case poll
            case update
            case admin_sign_up = "admin.sign_up"
            case admin_report = "admin.report"
        }
    }
    
    public init(id: String, type: NotificationType, account: FediverseAccountEntity?, status: FediverseResponseEntity?, createdAt: Date) {
        self.id = id
        self.type = type
        self.account = account
        self.status = status
        self.createdAt = createdAt
    }
}
