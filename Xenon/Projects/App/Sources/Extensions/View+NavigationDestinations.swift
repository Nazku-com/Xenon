//
//  View+NavigationDestinations.swift
//  xenon
//
//  Created by 김수환 on 3/8/25.
//

import SwiftUI
import UIComponent
import FediverseFeature

extension View {
    
    @ViewBuilder
    func destinationView(from notification: Notification, oAuthData: OauthData) -> some View {
        if let content = notification.object as? FediverseResponseEntity {
            FediverseContentDetailView(model: .init(oAuthData: oAuthData, navigatedContent: content))
        } else if let fediverseAccountEntity = notification.object as? FediverseAccountEntity {
            FediverseProfileView(model: .init(oAuthData: oAuthData, fediverseAccountData: fediverseAccountEntity))
        } else if let initializer = notification.object as? FollowingListView.Initializer {
            FollowingListView(selectedContent: initializer.contentType, manager: .init(userID: initializer.id))
        }
        else {
            Text("Unknown")
        }
    }
    
    @ViewBuilder
    func destinationView(from type: NavigationType, oAuthData: OauthData) -> some View {
        switch type {
        case .userAccountInfo(let fediverseAccountEntity):
            FediverseProfileView(model: .init(oAuthData: oAuthData, fediverseAccountData: fediverseAccountEntity))
        case .login:
            LoginView(model: .init())
                .onAppear {
                    NavigationBarModel.shared.shrinkBarPublisher.send(true)
                }.onDisappear {
                    NavigationBarModel.shared.shrinkBarPublisher.send(false)
                }
        case .url(let urlType):
            switch urlType {
            case .handle(let account):
                FediverseProfileView(model: .init(oAuthData: oAuthData, fediverseAccountData: account))
            case .hashtag(let tag):
                StaggeredGridView(model: FediverseStaggeredGridViewModel(
                    numberOfRows: GridRowNumerManager.shared.numberOfRows,
                    timeline: .hashtag(tag: tag)
                ))
                .navigationTitle("#\(tag)")
            case .url(let url):
                WKWebViewWrapper(url: url) // TODO: - show alert before present webview
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            ShareLink(item: url)
                        }
                    }
                    .onAppear {
                        NavigationBarModel.shared.shrinkBarPublisher.send(true)
                    }.onDisappear {
                        NavigationBarModel.shared.shrinkBarPublisher.send(false)
                    }
            }
        }
    }
}
