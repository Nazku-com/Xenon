//
//  Follow.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/23/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func follow(id: String) async -> Result<FediverseRelationship, NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.follow(from: url, token: token, id: id), dtoType: FediverseRelationshipsDTO.self)
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
    
    func unfollow(id: String) async -> Result<FediverseRelationship, NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.unfollow(from: url, token: token, id: id), dtoType: FediverseRelationshipsDTO.self)
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
    
    func followers(id: String) async -> Result<[FediverseAccountEntity], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.followers(from: url, token: token, id: id), dtoType: [MastodonResponseDTO.Account].self)
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
    
    func following(id: String) async -> Result<[FediverseAccountEntity], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.following(from: url, token: token, id: id), dtoType: [MastodonResponseDTO.Account].self)
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
}
