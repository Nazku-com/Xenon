//
//  NodeInfoEntity.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation
import NetworkingFeature

struct NodeInfoEntity: NetworkingEntityType {
    let version: String
    let nodeType: NodeType?
    let softwareVersion: String
    
    public enum NodeType: String, Codable {
        
        case mastodon
        case misskey
    }    
}
