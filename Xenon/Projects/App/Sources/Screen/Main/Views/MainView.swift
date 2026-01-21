import SwiftUI
import Combine
import Sugar
import UIComponent
import FediverseFeature

struct MainView: View {
    
    @State var feedsViewModel: FeedsViewModel = .init(feeds: [])
    @State var mainViewModel: MainViewModel
    @AppStorage("selectedTab") private var selectedTab = TabItem.feed
    
    @State var isSheetShown = false
    
    var body: some View {
        if let currentOAuthData = mainViewModel.currentOAuthData {
            contentView(currentOAuthData: currentOAuthData)
                .navigationTitle("")
                .environment(mainViewModel)
                .environment(\.openURL, OpenURLAction { url in
                    Task { @MainActor in
                        mainViewModel.output.send(.openURL(url))
                    }
                    return .handled
                })
                .onOpenURL { _ in }
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func contentView(currentOAuthData: OauthData) -> some View {
        tabView(oAuthData: currentOAuthData)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button {
                            mainViewModel.output.send(.toggleSideBarState)
                        } label: {
                            Text("asdf")
                        }
                    } label: {
                        ImageView(url: currentOAuthData.user?.avatar)
                            .frame(width: 32, height: 32)
                            .clipShape(.circle)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    switch selectedTab {
                    case .feed:
                        feedTapIndicator
                    default:
                        EmptyView()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    switch selectedTab {
                    case .feed:
                        Button {
                            isSheetShown.toggle()
                        } label: {
                            Image(systemName: "pencil.and.scribble")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(4)
                                .frame(width: 32, height: 32)
                        }
                    case .notifications:
                        EmptyView()
                    case .search:
                        EmptyView()
                    }
                }
            }
            .sheet(isPresented: $isSheetShown) {
                Text("!@#")
            }
    }
    
    @State var feedTapIndicatorPosition: String?
    @ViewBuilder
    private var feedTapIndicator: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(feedsViewModel.feeds) { feed in
                    Text(feed.title)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .glassy(tintColor: feed.title == feedsViewModel.selectedTab ? .blue : nil)
                        .id(feed.title)
                        .onTapGesture {
                            feedsViewModel.selectedTab = feed.title
                        }
                }
            }
        }
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .scrollPosition(id: $feedTapIndicatorPosition)
        .onChange(of: feedsViewModel.selectedTab) { _, newValue in
            withAnimation {
                feedTapIndicatorPosition = newValue
            }
        }
    }
    
    @ViewBuilder
    private func tabView(oAuthData: OauthData) -> some View {
        if #available(iOS 18.0, *) {
            TabView(selection: $selectedTab) {
                Tab("Feed", systemImage: "house", value: .feed) {
                    FeedsView(oAuthData: oAuthData, model: feedsViewModel)
                }
                Tab("noti", systemImage: "envelope.fill", value: .notifications) {
                    NotificationsView(oAuthdata: oAuthData)
                }
                Tab(value: .search, role: .search) {
                    Text("C")
                }
            }
        } else {
            TabView(selection: $selectedTab) {
                FeedsView(oAuthData: oAuthData, model: feedsViewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Feed")
                    }
                    .tag(TabItem.feed)
                NotificationsView(oAuthdata: oAuthData)
                    .tabItem {
                        Image(systemName: "envelope.fill")
                        Text("noti")
                    }
                    .tag(TabItem.notifications)
                Text("C")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("search")
                    }
                    .tag(TabItem.search)
            }
        }
    }
}

enum TabItem: String, CaseIterable {
    
    case feed
    case notifications
    case search
}
