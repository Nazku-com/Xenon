//
//  Timeline.swift
//  FediverseFeature
//
//  Created by 김수환 on 12/14/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func timeline(
        type: TimelineType,
        minID: String? = nil,
        maxID: String? = nil,
        pagenationURL: URL? = nil
    ) async -> Result<(data: [FediverseResponseEntity], urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible:
            guard let pagenationURL else {
                let data = await NetworkingService().request(
                    api: MastodonAPI.timeline(from: url, token: token, of: type, minID: minID, maxID: maxID),
                    dtoType: [MastodonResponseDTO].self
                )
                return data
            }
            let data = await NetworkingService().request(
                api: MastodonAPI.get(from: pagenationURL, token: token),
                dtoType: [MastodonResponseDTO].self
            )
            return data
            
        case .hollo:
            guard let pagenationURL else {
                let data = await NetworkingService().request(
                    api: HolloAPI.timeline(from: url, token: token, of: type, minID: minID, maxID: maxID),
                    dtoType: [MastodonResponseDTO].self
                )
                return data
            }
            let data = await NetworkingService().request(
                api: MastodonAPI.get(from: pagenationURL, token: token),
                dtoType: [MastodonResponseDTO].self
            )
            return data
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }
}

public enum TimelineType: Equatable, Codable, Hashable {
    
    case home
    case federated
    case tranding
    case hashtag(tag: String)
}
