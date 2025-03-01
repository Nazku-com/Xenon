//
//  NodeInfoDT.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

struct NodeInfoDTO: NetworkingDTOType {
    
    let version: String
    let software: NodeSoftwareInfoDTO
    
    func toEntity() -> NodeInfoEntity {
        .init(
            version: version,
            nodeType: .init(rawValue: software.name.lowercased()),
            softwareVersion: software.version
        )
    }
}

struct NodeSoftwareInfoDTO: Codable {
    let name: String
    let version: String
}
