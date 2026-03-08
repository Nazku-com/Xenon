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
            if selectedTab == nil || !feeds.contains(where: { $0.title == selectedTab }) {
                selectedTab = feeds.first?.title
            }
        }
    }
    var selectedTab: String?

    func addFeed(_ item: FeedItem) {
        feeds.append(item)
    }

    func removeFeed(at index: Int) {
        guard feeds.indices.contains(index) else { return }
        feeds.remove(at: index)
    }

    func removeFeed(title: String) {
        feeds.removeAll { $0.title == title }
    }

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

    @Environment(MainViewModel.self) private var mainViewModel
    let oAuthData: OauthData
    var model: FeedsViewModel
    @State private var scrollPosition: String?
    @State private var isCreateFeedPresented: Bool = false

    var body: some View {
        if model.feeds.isEmpty {
            ContentUnavailableView {
                Label("No Feeds", systemImage: "newspaper")
            } description: {
                Text("Add a feed to get started")
            } actions: {
                Button("Add Feed") {
                    isCreateFeedPresented = true
                }
                .buttonStyle(.bordered)
            }
            .sheet(isPresented: $isCreateFeedPresented) {
                createFeedSheet
            }
        } else {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(model.feeds) { feed in
                        FeedView(model: feed.model)
                            .environment(mainViewModel)
                            .containerRelativeFrame(.horizontal)
                            .id(feed.title)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .scrollPosition(id: $scrollPosition)
            .onChange(of: scrollPosition) { _, newValue in
                if let newValue {
                    model.selectedTab = newValue
                }
            }
            .onChange(of: model.selectedTab) { _, newValue in
                if scrollPosition != newValue {
                    withAnimation {
                        scrollPosition = newValue
                    }
                }
            }
            .onAppear {
                scrollPosition = model.selectedTab
            }
        }
    }

    @ViewBuilder
    private var createFeedSheet: some View {
        CreateFeedView { title, timelineType, columns in
            let feedModel = FeedViewModel(oAuthdata: oAuthData, columns: columns, timeline: timelineType)
            model.addFeed(.init(title: title, model: feedModel))
        }
    }
}
