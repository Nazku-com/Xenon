//
//  WellKnownNodeInfoDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

struct WellKnownNodeInfoDTO: NetworkingDTOType {
    
    let links: [LinkDTO]
    
    func toEntity() -> WellKnownNodeInfoEntity {
        .init(rel: URL(string: links.first?.rel ?? ""), href: URL(string: links.first?.href ?? ""))
    }
    
    struct LinkDTO: Codable {
        let rel: String
        let href: String
    }

}
