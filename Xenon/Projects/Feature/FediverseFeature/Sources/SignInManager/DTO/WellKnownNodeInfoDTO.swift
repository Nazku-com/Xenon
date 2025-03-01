//
//  WellKnownNodeInfoDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

struct WellKnownNodeInfoDTO: NetworkingDTOType {
    
    let links: [WellKnownNodeInfoURLDTO]
    
    func toEntity() -> WellKnownNodeInfoEntity {
        .init(rel: URL(string: links.first?.rel ?? ""), href: URL(string: links.first?.href ?? ""))
    }
}

struct WellKnownNodeInfoURLDTO: Codable {
    let rel: String
    let href: String
}
