//
//  Favourite.swift
//  FediverseFeature
//
//  Created by Claude on 2/1/26.
//  Copyright © 2026 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {

    func favourite(id: String) async -> Result<(data: FediverseResponseEntity, urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            return await NetworkingService().request(
                api: MastodonAPI.favourite(from: url, token: token, id: id),
                dtoType: MastodonResponseDTO.self
            )
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }

    func unfavourite(id: String) async -> Result<(data: FediverseResponseEntity, urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            return await NetworkingService().request(
                api: MastodonAPI.unfavourite(from: url, token: token, id: id),
                dtoType: MastodonResponseDTO.self
            )
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }
}
