//
//  UserInfo.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/28/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func userInfo(handle: String) async -> FediverseAccountEntity? {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.lookup(from: url, token: token, handle: handle), dtoType: MastodonResponseDTO.Account.self)
            switch result {
            case .success(let success):
                return success
            case .failure(let failure):
                return nil
            }
            
        case .misskey:
            // use as username
            var username: String
            var host: String?
            var builder = handle
            if builder.hasPrefix("@") {
                builder.removeFirst()
            }
            if builder.contains("@") {
                let comps = builder.components(separatedBy: "@")
                assert(comps.count == 2)
                username = comps.first ?? ""
                host = comps.last
            } else {
                username = builder
            }
            if (host ?? "").isEmpty {
                host = url.host
            }
            let result = await NetworkingService().request(api: MisskeyAPI.userShow(from: url, token: token, userName: username, host: host), dtoType: MisskeyAccountDTO.self)
            switch result {
            case .success(let success):
                return success
            case .failure(let failure):
                return nil
            }
        }
    }
}

