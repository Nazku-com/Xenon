//
//  OauthTokenEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public struct OauthTokenEntity: NetworkingEntityType, Hashable, Sendable {
    
    public let accessToken: String
    public let createdAt: Double
    
    public init(accessToken: String, createdAt: Double) {
        self.accessToken = accessToken
        self.createdAt = createdAt
    }
}
