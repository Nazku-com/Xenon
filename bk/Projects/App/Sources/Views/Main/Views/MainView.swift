//
//  MainView.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import SwiftUI
import FediverseFeature
import UIComponent
import Kingfisher

struct MainView: View {
    
    @ObservedObject var model: MainViewModel
    @Binding var routerPath: RouterPath
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            VStack(spacing: 4) {
                HStack {
                    if let user = model.oAuthData.user {
                        Button {
                            SideBarViewModel.shared.sideBarOpenPublisher.send(true)
                        } label: {
                            KFImage(user.avatar)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 32, height: 32)
                                .clipShape(.circle)
                        }
                        .softButtonStyle(Circle(), padding: 1)
                        .padding(.leading, 16)
                        .padding(.bottom, 4)
                    }
                    SegmentedControl(
                        contentList: model.tabs.compactMap({ $0.title }),
                        selectedContent: $model.selectedTab
                    )
                }
                TabView(selection: $model.selectedTab) {
                    ForEach(model.tabs, id: \.title) { tab in
                        MainContentView(tab: tab, path: $routerPath)
                            .tag(tab.title)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(Color.Neumorphic.main)
            .onAppear {
                let numberOfPath = routerPath.path.count
                SideBarViewModel.shared.sideBarOpenablePublisher.send(numberOfPath == 0)
            }
            .onChange(of: routerPath.path.count, { _, newValue in
                SideBarViewModel.shared.sideBarOpenablePublisher.send(newValue == 0)
            })
            .navigationDestination(for: Notification.self) { notification in
                if let oAuthData = OAuthDataManager.shared.currentOAuthData {
                    destinationView(from: notification, oAuthData: oAuthData)
                        .environment(routerPath)
                        .onAppear {
                            let numberOfPath = routerPath.path.count
                            SideBarViewModel.shared.sideBarOpenablePublisher.send(numberOfPath == 0)
                        }
                }
            }
            .navigationDestination(for: NavigationType.self) { notification in
                if let oAuthData = OAuthDataManager.shared.currentOAuthData {
                    destinationView(from: notification, oAuthData: oAuthData)
                        .environment(routerPath)
                        .onAppear {
                            let numberOfPath = routerPath.path.count
                            SideBarViewModel.shared.sideBarOpenablePublisher.send(numberOfPath == 0)
                        }
                }
            }
        }
    }
}

#Preview {
    
    ContentView(oAuthData: FediverseMockData.oAuthData)
}
