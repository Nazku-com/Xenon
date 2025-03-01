//
//  RevokeToken.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/28/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func revokeToken() async {
        switch nodeType {
        case .mastodon, .hollo:
            return
            
        case .misskey:
            let result = await NetworkingService().request(api: MisskeyAPI.revokeToken(from: url, token: token)) // TODO: -currently not work
            print("Result: \(String(data: result ?? Data(), encoding: .utf8))")
        }
    }
}


