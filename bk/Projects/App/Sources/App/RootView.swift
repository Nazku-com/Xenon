//
//  RootView.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import SwiftUI
import FediverseFeature

struct RootView: View {
    
    @ObservedObject var oAuthDataManager = OAuthDataManager.shared
    
    var body: some View {
        if let oAuthData = oAuthDataManager.currentOAuthData ?? oAuthDataManager.oAuthDatas.first {
            ContentView(oAuthData: oAuthData)
        } else {
            LoginView(model: .init())
        }
    }
}

#Preview {
    RootView()
}
