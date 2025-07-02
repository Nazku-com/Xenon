//
//  MisskeyOauthTokenEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

struct MisskeyOauthTokenEntity: NetworkingEntityType {
    
    public let token: OauthTokenEntity
    public let user: FediverseAccountEntity?
}
