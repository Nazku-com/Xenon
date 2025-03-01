//
//  NodeType.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import AuthenticationServices
import SwiftUI
import os


public enum NodeType: String, Codable {
    
    case mastodon
    case hollo
    case misskey
    
    func startSignIn(into url: URL, appInfo: AppInfoType, session: WebAuthenticationSession) async -> Result<OauthData, SignInError> {
        switch self {
        case .mastodon, .hollo:
            await MastodonSignInManager(webAuthenticationSession: session, nodeType: self).signIn(into: url, appInfo: appInfo)
        case .misskey:
            await MisskeySignInManager(webAuthenticationSession: session).signIn(into: url, appInfo: appInfo)
        }
    }
}
