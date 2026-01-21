//
//  FollowRequest.swift
//  FediverseFeature
//
//  Created by 김수환 on 3/24/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func followRequest() async -> Result<[FediverseAccountEntity], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let data = await NetworkingService().request(
                api: MastodonAPI.followRequest(from: url, token: token),
                dtoType: [MastodonResponseDTO.Account].self
            )
            return data
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
    
    func acceptFollow(id: String) async -> Result<FediverseRelationship, NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let data = await NetworkingService().request(
                api: MastodonAPI.acceptFollow(from: url, token: token, id: id),
                dtoType: FediverseRelationshipsDTO.self
            )
            return data
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
}
