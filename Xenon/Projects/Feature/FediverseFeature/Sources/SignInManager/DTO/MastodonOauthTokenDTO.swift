//
//  MastodonOauthTokenDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

struct MastodonOauthTokenDTO: NetworkingDTOType {
    
    public let accessToken: String
    public let tokenType: String
    public let scope: String
    public let createdAt: Double
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    public func toEntity() -> OauthTokenEntity {
        .init(
            accessToken: accessToken,
            createdAt: createdAt
        )
    }
}
