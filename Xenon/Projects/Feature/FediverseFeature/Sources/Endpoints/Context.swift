//
//  Context.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/28/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public struct FediverseContext: NetworkingEntityType {
    
    public let ancestors: [FediverseResponseEntity]
    public let descendants: [FediverseResponseEntity]
}

public extension OauthData {
    
    func context(for id: String) async -> FediverseContext? {
        switch nodeType {
        case .mastodon, .hollo:
            let data = await NetworkingService().request(api: MastodonAPI.context(from: url, token: token, id: id), dtoType: [String: [MastodonResponseDTO]].self)
            switch data {
            case .success(let success):
                return success
            case .failure(let failure):
                return nil
            }
            
        case .misskey:
            let data = await NetworkingService().request(api: MisskeyAPI.replies(from: url, token: token, noteId: id), dtoType: [MisskeyResponseDTO].self)
            switch data {
            case .success(let success):
                return .init(ancestors: [], descendants: success.sorted(by: { $0.createdAt < $1.createdAt }) ) // TODO: -
            case .failure(let failure):
                return nil
            }
        }
    }
}


extension [String: [MastodonResponseDTO]]: @retroactive NetworkingDTOType {
    
    public typealias EntityType = FediverseContext
    
    public func toEntity() -> EntityType {
        var ancestors = [FediverseResponseEntity]()
        var descendants = [FediverseResponseEntity]()
        if let ancestorsData = self["ancestors"]?.toEntity() {
            ancestors.append(contentsOf: ancestorsData)
        }
        if let descendantsData = self["descendants"]?.toEntity() {
            descendants.append(contentsOf: descendantsData)
        }
        return .init(ancestors: ancestors, descendants: descendants)
    }
}
