//
//  MisskeyOauthTokenEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//


import Foundation
import NetworkingFeature

struct MisskeyOauthTokenEntity: NetworkingEntityType {
    
    public let token: OauthTokenEntity
    public let user: FediverseAccountEntity?
}
