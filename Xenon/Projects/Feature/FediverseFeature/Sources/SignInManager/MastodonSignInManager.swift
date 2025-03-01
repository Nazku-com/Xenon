//
//  MastodonSignInManager.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import AuthenticationServices
import Alamofire
import NetworkingFeature
import SwiftUI
import os

struct MastodonSignInManager {
    private var webAuthenticationSession: WebAuthenticationSession
    private let nodeType: NodeType
    
    func signIn(into url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        let service = NetworkingService()
        
        let result = await service.request(api: MastodonAPI.registerApp(from: url, appInfo: appInfo), dtoType: MastodonAppDTO.self)
        switch result {
        case .success(let entity):
            return await continueSignIn(into: url, entity: entity, appInfo: appInfo)
        case .failure(let failure):
            return .failure(.appRegisterFailed)
        }
    }
    
    @MainActor
    private func continueSignIn(into url: URL, entity: MastodonAppEntity, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host()
        components.path += "/oauth/authorize"
        components.queryItems = [
            .init(name: "response_type", value: "code"),
            .init(name: "client_id", value: entity.clientId),
            .init(name: "redirect_uri", value: appInfo.scheme),
            .init(name: "scope", value: "read write follow push"),
        ]
        
        guard let oauthURL = components.url else {
            return .failure(.urlNotFound)
        }
        
        if let urlWithToken = try? await webAuthenticationSession.authenticate(
            using: oauthURL,
            callbackURLScheme: appInfo.clientName
        ) {
            return await createOauthData(urlWithToken: urlWithToken, url: url, entity: entity, appInfo: appInfo)
        } else {
            return .failure(.createTokenFailed)
        }
    }
    
    private func createOauthData(urlWithToken: URL, url: URL, entity: MastodonAppEntity, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        guard let components = URLComponents(url: urlWithToken, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            return .failure(.createTokenFailed)
        }
        
        let service = NetworkingService()
        let result = await service.request(
            api: MastodonAPI.createToken(from: url, code: code, clientId: entity.clientId, clientSecret: entity.clientSecret, appInfo: appInfo),
            dtoType: MastodonOauthTokenDTO.self
        )
        
        switch result {
        case .success(let token):
            let userInfo = await service.request(api: MastodonAPI.checkUserInfo(from: url, token: token), dtoType: MastodonResponseDTO.Account.self)
            switch userInfo {
            case .success(let success):
                return .success(.init(url: url, nodeType: nodeType, token: token, user: success))
            case .failure(let failure):
                return .success(.init(url: url, nodeType: nodeType, token: token, user: nil))
            }
            
        case .failure(let failure):
            return .failure(.createTokenFailed)
        }
    }
    
    init(webAuthenticationSession: WebAuthenticationSession, nodeType: NodeType) {
        self.webAuthenticationSession = webAuthenticationSession
        self.nodeType = nodeType
    }
}
