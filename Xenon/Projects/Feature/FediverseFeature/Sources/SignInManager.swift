//
//  SignInManager.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import AuthenticationServices
import NetworkingFeature
import SwiftUI
import os

public struct SignInManager {
    
    private var webAuthenticationSession: WebAuthenticationSession
    
    // MARK: - Interface
    
    public func signIn(into url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        let result = await service.request(api: NodeInfoAPI.nodeInfo(url: url), dtoType: WellKnownNodeInfoDTO.self)
        switch result {
        case .success(let success):
            guard let nodeInfoURL = success.data.href else {
                return .failure(.nodeInfoNotFound)
            }
            let nodeInfo = await service.request(api: NodeInfoAPI.get(url: nodeInfoURL), dtoType: NodeInfoDTO.self)
            switch nodeInfo {
            case .success(let success):
                guard let nodeType = success.data.nodeType else {
                    /// if nodeInfo is Not mastodon, hollo or misskey, server assume to be mastodonCompatible
                    return await NodeType.mastodonCompatible.startSignIn(into: url, appInfo: appInfo, session: webAuthenticationSession)
                }
                return await nodeType.startSignIn(into: url, appInfo: appInfo, session: webAuthenticationSession)
            case .failure:
                return .failure(.unsupportedServer)
            }
        case .failure:
            return .failure(.nodeInfoNotFound)
        }
    }
    
    // MARK: - Initialization
    
    public init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }
    
    private let service = NetworkingService()
}

extension NodeType {
    
    func startSignIn(into url: URL, appInfo: AppInfoType, session: WebAuthenticationSession) async -> Result<OauthData, SignInError> {
        switch self {
        case .mastodon, .mastodonCompatible, .hollo:
            await MastodonSignInManager(webAuthenticationSession: session, nodeType: self).signIn(into: url, appInfo: appInfo)
        case .misskey:
            await MisskeySignInManager(webAuthenticationSession: session).signIn(into: url, appInfo: appInfo)
        }
    }
}
