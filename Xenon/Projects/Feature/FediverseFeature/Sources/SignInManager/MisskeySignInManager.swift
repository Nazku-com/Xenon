//
//  MisskeySignInManager.swift
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

struct MisskeySignInManager {
    private var webAuthenticationSession: WebAuthenticationSession
    
    @MainActor
    func signIn(into url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        let createTokenAPI = MisskeyAPI.createSession(from: url, session: UUID().uuidString, appInfo: appInfo)
        
        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host()
        components.path += "/miauth/\(UUID().uuidString)"
        components.queryItems = createTokenAPI.queryItems
        guard let oauthURL = components.url else {
            return .failure(.urlNotFound)
        }
        
        if let urlWithToken = try? await webAuthenticationSession.authenticate(
            using: oauthURL,
            callbackURLScheme: appInfo.clientName
        ) {
            return await createOauthData(urlWithToken: urlWithToken, url: url, appInfo: appInfo)
        } else {
            return .failure(.createTokenFailed)
        }
    }
    
    
    private func createOauthData(urlWithToken: URL, url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        guard let components = URLComponents(url: urlWithToken, resolvingAgainstBaseURL: false),
              let session = components.queryItems?.first(where: { $0.name == "session" })?.value
        else {
            return .failure(.createTokenFailed)
        }
        
        let service = NetworkingService()
        let oAuthData = await service.request(api: MisskeyAPI.createToken(from: url, session: session), dtoType: MisskeyOauthTokenDTO.self)
        switch oAuthData {
        case .success(let success):
            return .success(.init(url: url, nodeType: .misskey, token: success.token, user: success.user))
        case .failure:
            return .failure(.createTokenFailed)
        }
    }
    
    init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }
}
