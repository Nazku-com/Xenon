//
//  Like.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/30/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func createReaction(to id: String, reaction: String = "♥") async -> FediverseResponseEntity? {
        switch nodeType {
        case .mastodon, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.setFavorite(from: url, token: token, id: id), dtoType: MastodonResponseDTO.self)
            switch result {
            case .success(let success):
                return success
            case .failure(let failure):
                return nil
            }
        case .misskey:
            let _ = await NetworkingService().request(api: MisskeyAPI.createReaction(from: url, token: token, noteId: id, reaction: reaction))
            let newNoteStatusData = await NetworkingService().request(api: MisskeyAPI.singleNote(from: url, token: token, noteId: id), dtoType: MisskeyResponseDTO.self)
            switch newNoteStatusData {
            case .success(let success):
                return success
            case .failure(let failure):
                return nil
            }
        }
    }
    
    func removeReaction(from id: String) async -> FediverseResponseEntity? {
        switch nodeType {
        case .mastodon, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.unFavorite(from: url, token: token, id: id), dtoType: MastodonResponseDTO.self)
            switch result {
            case .success(let success):
                return success
            case .failure(_):
                return nil
            }
        case .misskey:
            let _ = await NetworkingService().request(api: MisskeyAPI.deleteReaction(from: url, token: token, noteId: id))
            let newNoteStatusData = await NetworkingService().request(api: MisskeyAPI.singleNote(from: url, token: token, noteId: id), dtoType: MisskeyResponseDTO.self)
            switch newNoteStatusData {
            case .success(let success):
                return success
            case .failure(_):
                return nil
            }
        }
    }
}
