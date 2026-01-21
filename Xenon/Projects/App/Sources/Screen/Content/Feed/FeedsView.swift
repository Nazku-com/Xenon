//
//  FeedsView.swift
//  xenon
//
//  Created by 김수환 on 1/1/26.
//

import SwiftUI
import FediverseFeature

@Observable
@MainActor
final class FeedsViewModel {
    
    var feeds: [FeedItem] {
        didSet {
            if selectedTab == nil {
                selectedTab = feeds.first?.title
            }
        }
    }
    var selectedTab: String?
    init(feeds: [FeedItem]) {
        self.feeds = feeds
    }
    
    struct FeedItem: Identifiable {
        
        var id: UUID = UUID()
        let title: String
        let model: FeedViewModel
    }
}

struct FeedsView: View {
    
    let oAuthData: OauthData
    @State var model: FeedsViewModel
    var body: some View {
        if model.feeds.isEmpty {
            Text("add Feed")
                .onTapGesture {
                    model.feeds.append(.init(title: "home", model: .init(oAuthdata: oAuthData, columns: 1, timeline: .home)))
                    model.feeds.append(.init(title: "federated", model: .init(oAuthdata: oAuthData, columns: 2, timeline: .federated)))
                    model.feeds.append(.init(title: "tranding", model: .init(oAuthdata: oAuthData, columns: 2, timeline: .tranding)))
                    model.feeds.append(.init(title: "home2", model: .init(oAuthdata: oAuthData, columns: 1, timeline: .home)))
                    model.feeds.append(.init(title: "federated2", model: .init(oAuthdata: oAuthData, columns: 2, timeline: .federated)))
                    model.feeds.append(.init(title: "tranding2", model: .init(oAuthdata: oAuthData, columns: 2, timeline: .tranding)))
                }
        } else {
            TabView(selection: $model.selectedTab) {
                ForEach(model.feeds) { feed in
                    FeedView(model: feed.model)
                        .tag(feed.title)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(edges: .vertical)
            .padding(.horizontal, 4)
        }
    }
}
