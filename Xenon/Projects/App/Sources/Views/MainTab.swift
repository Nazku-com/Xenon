//
//  MainTab.swift
//  xenon
//
//  Created by 김수환 on 2/12/25.
//

import SwiftUI
import FediverseFeature

enum MainTab: String, CaseIterable {
    
    case home
    case search
    case message
    
    @ViewBuilder
    func view(
        oAuthData: OauthData,
        path: Binding<NavigationPath>
    ) -> some View {
        switch self {
        case .home:
            MainView(model: .init(oAuthData: oAuthData))
        case .search:
            Text("search")
        case .message:
            NotificationView(oAuthData: oAuthData, path: path)
        }
    }
}
