//
//  MisskeyOauthTokenDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//


import Foundation
import NetworkingFeature

struct MisskeyOauthTokenDTO: NetworkingDTOType {
    
    public let token: String
    public let user: MisskeyAccountDTO
    
    func toEntity() async throws -> MisskeyOauthTokenEntity {
        .init(
            token: .init(accessToken: token, createdAt: Date().timeIntervalSince1970),
            user: try await user.toEntity()
        )
    }
}
