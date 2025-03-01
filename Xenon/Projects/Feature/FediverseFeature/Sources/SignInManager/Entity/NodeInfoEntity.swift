//
//  NodeInfoEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

struct NodeInfoEntity: NetworkingEntityType {
    
    let version: String
    let nodeType: NodeType?
    let softwareVersion: String
}
