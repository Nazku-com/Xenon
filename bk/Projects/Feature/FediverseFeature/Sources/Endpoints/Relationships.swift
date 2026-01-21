//
//  Relationships.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/23/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func relationships(id: String) async -> Result<[FediverseRelationship], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.relationships(from: url, token: token, id: id), dtoType: [FediverseRelationshipsDTO].self)
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
}
