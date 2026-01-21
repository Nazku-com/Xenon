//
//  LoginView.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import AuthenticationServices
import SwiftUI

struct LoginView: View {
    @ObservedObject var model: LoginViewModel
    
    @FocusState private var isInstanceURLFieldFocused: Bool
    @Environment(\.webAuthenticationSession) private var webAuthenticationSession
    var body: some View {
        Form {
            TextField("instance.url", text: $model.instanceName)
                .keyboardType(.URL)
                .textContentType(.URL)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .focused($isInstanceURLFieldFocused)
            
            Button {
                Task {
                    await model.login(session: webAuthenticationSession)
                }
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
