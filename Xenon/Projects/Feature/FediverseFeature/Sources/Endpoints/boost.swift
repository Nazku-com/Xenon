//
//  boost.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/25/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func boost(to id: String) async -> Result<FediverseResponseEntity, NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.boost(from: url, token: token, id: id), dtoType: MastodonResponseDTO.self)
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
    
    func unboost(from id: String) async -> Result<FediverseResponseEntity, NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.unboost(from: url, token: token, id: id), dtoType: MastodonResponseDTO.self)
            return result
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
}
