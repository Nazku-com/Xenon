//
//  LoginViewModel.swift
//  xenon
//
//  Created by 김수환 on 12/10/25.
//


import SwiftUI
import Combine
import AuthenticationServices
import FediverseFeature

@Observable
@MainActor
final class LoginViewModel {
    
    // MARK: - Interface
    
    var loginPublisher = PassthroughSubject<OauthData, Never>()
    var errorPublisher = PassthroughSubject<Error, Never>()
    var instanceName: String = ""
    var isLoading = false
    func login(session: WebAuthenticationSession) {
        Task {
            guard !isLoading else { return }
            isLoading = true
            defer { isLoading = false }
            guard let url = instanceName.starts(with: "http") ? URL(string: instanceName) : URL(string: "https://\(instanceName)") else {
//                errorPublisher.send(failure)
                return // TODO: -
            }
            let result = await SignInManager(webAuthenticationSession: session).signIn(into: url, appInfo: AppInfo.shared)
            switch result {
            case .success(let success):
                loginPublisher.send(success)
            case .failure(let failure):
                errorPublisher.send(failure)
            }
        }
    }
    
    // MARK: - Attribute
    
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
}
