//
//  LoginView.swift
//  xenon
//
//  Created by 김수환 on 10/26/25.
//

import SwiftUI
import Combine
import AuthenticationServices

struct LoginView: View {
    
    @State var model: LoginViewModel = .init()
    
    @FocusState private var isInstanceURLFieldFocused: Bool
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    var body: some View {
        Form {
            TextField("instance.url", text: $model.instanceName)
                .onSubmit {
                    model.login(session: webAuthenticationSession)
                }
                .keyboardType(.URL)
                .textContentType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isInstanceURLFieldFocused)
            
            Button {
                model.login(session: webAuthenticationSession)
            } label: {
                Text("Sign in")
            }
            
        }
        .formStyle(.grouped)
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            isInstanceURLFieldFocused = true
        }
    }
}
