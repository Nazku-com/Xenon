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
    
    var body: some View {
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
                    MainContentView(tab: tab)
                        .tag(tab.title)
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color.Neumorphic.main)
    }
}

#Preview {
    
    ContentView(oAuthData: FediverseMockData.oAuthData)
}
