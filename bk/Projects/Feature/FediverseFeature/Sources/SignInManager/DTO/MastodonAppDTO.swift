//
//  MastodonAppDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public struct MastodonAppDTO: NetworkingDTOType {
    
    let clientId: String
    let clientSecret : String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
    
    public func toEntity() -> MastodonAppEntity {
        .init(
            clientId: clientId,
            clientSecret: clientSecret
        )
    }
}
