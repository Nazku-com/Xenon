//
//  MisskeyOauthTokenDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

struct MisskeyOauthTokenDTO: NetworkingDTOType {
    
    public let token: String
    public let user: MisskeyAccountDTO
    
    func toEntity() -> MisskeyOauthTokenEntity {
        .init(
            token: .init(accessToken: token, createdAt: Date().timeIntervalSince1970),
            user: user.toEntity()
        )
    }
}
