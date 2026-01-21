//
//  LoginViewModel.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import SwiftUI
import FediverseFeature
import AuthenticationServices

final class LoginViewModel: ObservableObject {
    
    @Published private(set) var isLoading: Bool = false
    @Published var instanceName: String
    
    init(instanceName: String = "xenon.social") {
        self.instanceName = instanceName
    }
    
    @MainActor
    func login(session: WebAuthenticationSession) async {
        guard !isLoading else { return }
        isLoading = true
        guard let url = URL(string: "https://\(instanceName)") else {
            return // TODO: -
        }
        let result = await SignInManager(webAuthenticationSession: session).signIn(into: url, appInfo: AppInfo.shared)
        switch result {
        case .success(let oAuthData):
            OAuthDataManager.shared.oAuthDatas.append(oAuthData)
            OAuthDataManager.shared.currentOAuthData = oAuthData
        case .failure(let failure):
            print(failure)
        }
        isLoading = false
    }
}
