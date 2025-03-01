//
//  OauthData.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation

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
