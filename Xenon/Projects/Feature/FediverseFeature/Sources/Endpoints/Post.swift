//
//  Post.swift
//  FediverseFeature
//
//  Created by 김수환 on 3/1/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func post(content: String, visibility: FediverseResponseEntity.Visibility) async -> Result<FediverseResponseEntity, NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .hollo:
            let result = await NetworkingService().request(
                api: MastodonAPI.post(
                    from: url,
                    token: token,
                    content: content,
                    visibility: visibility
                ),
                dtoType: MastodonResponseDTO.self
            )
            return result
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
}
