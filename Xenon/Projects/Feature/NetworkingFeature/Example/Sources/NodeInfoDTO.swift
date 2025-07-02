//
//  NodeInfoDTO.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation
import NetworkingFeature

struct NodeInfoDTO: NetworkingDTOType {
    let version: String
    let software: NodeSoftwareInfoDTO
    
    struct NodeSoftwareInfoDTO: Codable {
        let name: String
        let version: String
    }
    
    func toEntity() -> some NetworkingEntityType {
        NodeInfoEntity(
            version: version,
            nodeType: .init(rawValue: software.name.lowercased()),
            softwareVersion: software.version
        )
    }
}
