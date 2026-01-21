//
//  Timeline.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func timeline(
        type: TimelineType,
        minID: String? = nil,
        maxID: String? = nil
    ) async -> Result<[FediverseResponseEntity], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible:
            let data = await NetworkingService().request(
                api: MastodonAPI.timeline(from: url, token: token, of: type, minID: minID, maxID: maxID),
                dtoType: [MastodonResponseDTO].self
            )
            
            return data
            
        case .hollo:
            let data = await NetworkingService().request(
                api: HolloAPI.timeline(from: url, token: token, of: type, minID: minID, maxID: maxID),
                dtoType: [MastodonResponseDTO].self
            )
            
            return data
            
        case .misskey:
            let data = await NetworkingService().request(
                api: MisskeyAPI.timeline(
                    from: url,
                    token: token,
                    of: type,
                    sinceID: minID,
                    untilID: maxID
                ),
                dtoType: [MisskeyResponseDTO].self
            )
            
            return data
        }
    }
}
