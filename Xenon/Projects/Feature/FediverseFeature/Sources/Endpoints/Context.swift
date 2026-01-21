//
//  Context.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/7/26.
//  Copyright © 2026 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
public extension OauthData {
    
    func context(for id: String) async -> Result<(data: FediverseContext, urlResponse: URLResponse), NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            return await NetworkingService().request(api: MastodonAPI.context(from: url, token: token, id: id), dtoType: [String: [MastodonResponseDTO]].self)
        case .misskey:
            return .failure(.networkError("not yet implemented")) // TODO: -
        }
    }
}

public struct FediverseContext: NetworkingEntityType {
    
    public let ancestors: [FediverseResponseEntity]
    public let descendants: [FediverseResponseEntity]
}

extension [String: [MastodonResponseDTO]]: @retroactive NetworkingDTOType {
    
    public typealias EntityType = FediverseContext
    
    public func toEntity() async -> EntityType {
        let ancestors: [FediverseResponseEntity]? = try? await self["ancestors"]?.toEntity()
        let descendants: [FediverseResponseEntity]? = try? await self["descendants"]?.toEntity()
        return .init(ancestors: ancestors ?? [], descendants: descendants ?? [])
    }
}
