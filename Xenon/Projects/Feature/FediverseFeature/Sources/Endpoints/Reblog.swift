//
//  Reblog.swift
//  FediverseFeature
//
//  Created by Claude on 2/1/26.
//  Copyright © 2026 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {

    func reblog(id: String) async -> Result<(data: FediverseResponseEntity, urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            return await NetworkingService().request(
                api: MastodonAPI.reblog(from: url, token: token, id: id),
                dtoType: MastodonResponseDTO.self
            )
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }

    func unreblog(id: String) async -> Result<(data: FediverseResponseEntity, urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            return await NetworkingService().request(
                api: MastodonAPI.unreblog(from: url, token: token, id: id),
                dtoType: MastodonResponseDTO.self
            )
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }
}
