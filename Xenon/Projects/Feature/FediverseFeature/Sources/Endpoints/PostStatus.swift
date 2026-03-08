//
//  PostStatus.swift
//  FediverseFeature
//
//  Created by Claude on 2/1/26.
//  Copyright © 2026 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {

    func postStatus(
        status: String,
        inReplyToID: String? = nil,
        visibility: FediverseResponseEntity.Visibility = .public,
        spoilerText: String? = nil
    ) async -> Result<(data: FediverseResponseEntity, urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            return await NetworkingService().request(
                api: MastodonAPI.postStatus(
                    from: url,
                    token: token,
                    status: status,
                    inReplyToID: inReplyToID,
                    visibility: visibility.rawValue,
                    spoilerText: spoilerText
                ),
                dtoType: MastodonResponseDTO.self
            )
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }
}
