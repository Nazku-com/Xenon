//
//  OauthData.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public struct OauthData: Equatable, Codable, Identifiable {
    
    public var id = UUID()
    public let url: URL
    public let nodeType: NodeType
    public let token: OauthTokenEntity
    public var user: FediverseAccountEntity?
    
    
    public init(url: URL, nodeType: NodeType, token: OauthTokenEntity, user: FediverseAccountEntity?) {
        self.url = url
        self.nodeType = nodeType
        self.token = token
        self.user = user
    }
}


public struct OauthTokenEntity: NetworkingEntityType, Hashable, Sendable {
    
    public let accessToken: String
    public let createdAt: Double
    
    public init(accessToken: String, createdAt: Double) {
        self.accessToken = accessToken
        self.createdAt = createdAt
    }
}
