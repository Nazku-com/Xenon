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
    
    func NavigationDestinations(for routerPath: Binding<RouterPath>) -> some View {
        self
            .onAppear {
                let numberOfPath = routerPath.path.wrappedValue.count
                SideBarViewModel.shared.sideBarOpenablePublisher.send(numberOfPath == 0)
            }
            .onChange(of: routerPath.path.wrappedValue.count, { _, newValue in
                SideBarViewModel.shared.sideBarOpenablePublisher.send(newValue == 0)
            })
            .navigationDestination(for: URLHandler.URLType.self) { urlType in
                if let oAuthData = OAuthDataManager.shared.currentOAuthData {
                    destinationView(from: urlType, oAuthData: oAuthData)
                        .environment(routerPath.wrappedValue)                    
                        .onAppear {
                            let numberOfPath = routerPath.path.wrappedValue.count
                            SideBarViewModel.shared.sideBarOpenablePublisher.send(numberOfPath == 0)
                        }
                }
            }
            .navigationDestination(for: Notification.self) { notification in
                if let oAuthData = OAuthDataManager.shared.currentOAuthData {
                    destinationView(from: notification, oAuthData: oAuthData)
                        .environment(routerPath.wrappedValue)
                        .onAppear {
                            let numberOfPath = routerPath.path.wrappedValue.count
                            SideBarViewModel.shared.sideBarOpenablePublisher.send(numberOfPath == 0)
                        }
                }
            }
            .navigationDestination(for: NavigationType.self) { notification in
                if let oAuthData = OAuthDataManager.shared.currentOAuthData {
                    destinationView(from: notification, oAuthData: oAuthData)
                        .environment(routerPath.wrappedValue)
                        .onAppear {
                            let numberOfPath = routerPath.path.wrappedValue.count
                            SideBarViewModel.shared.sideBarOpenablePublisher.send(numberOfPath == 0)
                        }
                }
            }
    }
    
    @ViewBuilder
    private func destinationView(from notification: Notification, oAuthData: OauthData) -> some View {
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
    private func destinationView(from type: NavigationType, oAuthData: OauthData) -> some View {
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
        }
    }
    
    @ViewBuilder
    private func destinationView(from urlType: URLHandler.URLType, oAuthData: OauthData) -> some View {
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
