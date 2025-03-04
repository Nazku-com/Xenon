//
//  SignInManager.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import AuthenticationServices
import Alamofire
import NetworkingFeature
import SwiftUI
import os

public struct SignInManager {
    private var webAuthenticationSession: WebAuthenticationSession
    
    public func signIn(into url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        let service = NetworkingService()
        
        let result = await service.request(api: NodeInfoAPI.nodeInfo(url: url), dtoType: WellKnownNodeInfoDTO.self)
        switch result {
        case .success(let success):
            guard let nodeInfoURL = success.href else {
                return .failure(.nodeInfoNotFound)
            }
            let nodeInfo = await service.request(api: NodeInfoAPI.get(url: nodeInfoURL), dtoType: NodeInfoDTO.self)
            switch nodeInfo {
            case .success(let success):
                guard let nodeType = success.nodeType else {
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
    
    public init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }
}
