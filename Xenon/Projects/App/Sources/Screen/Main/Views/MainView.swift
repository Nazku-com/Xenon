import SwiftUI
import Combine
import Sugar
import UIComponent
import FediverseFeature

struct MainView: View {
    
    @State var mainViewModel: MainViewModel
    @AppStorage("selectedTab") private var selectedTab = TabItem.feed

    @State var isComposeShown = false
    
    var body: some View {
        if let currentOAuthData = mainViewModel.currentOAuthData {
            contentView(currentOAuthData: currentOAuthData)
                .id(currentOAuthData.id)
                .navigationTitle("")
                .environment(mainViewModel)
                .environment(\.openURL, OpenURLAction { url in
                    Task { @MainActor in
                        mainViewModel.output.send(.openURL(url))
                    }
                    return .handled
                })
                .onOpenURL { _ in }
                .onChange(of: mainViewModel.currentOAuthData?.id) {
                    mainViewModel.feedsViewModel.feeds = []
                }
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
                        ForEach(mainViewModel.oAuthDatas) { account in
                            Button {
                                mainViewModel.switchAccount(to: account)
                            } label: {
                                let name = account.user?.displayName ?? account.user?.username ?? ""
                                let host = account.url.host() ?? ""
                                Label(
                                    "\(name) (\(host))",
                                    systemImage: mainViewModel.currentOAuthData?.id == account.id ? "checkmark.circle.fill" : "person.circle"
                                )
                            }
                        }
                        Divider()
                        Button {
                            mainViewModel.output.send(.addAccount)
                        } label: {
                            Label("Add Account", systemImage: "plus.circle")
                        }
                        Button {
                            mainViewModel.output.send(.toggleSideBarState)
                        } label: {
                            Label("Open Sidebar", systemImage: "sidebar.left")
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
                    Button {
                        isComposeShown.toggle()
                    } label: {
                        Image(systemName: "pencil.and.scribble")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(4)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .sheet(isPresented: $isComposeShown) {
                ComposeView(oAuthData: mainViewModel.currentOAuthData)
            }
    }
    
    @State var feedTapIndicatorPosition: String?
    @ViewBuilder
    private var feedTapIndicator: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(mainViewModel.feedsViewModel.feeds) { feed in
                    Text(feed.title)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .glassy(tintColor: feed.title == mainViewModel.feedsViewModel.selectedTab ? .blue : nil)
                        .id(feed.title)
                        .onTapGesture {
                            mainViewModel.feedsViewModel.selectedTab = feed.title
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                mainViewModel.feedsViewModel.removeFeed(title: feed.title)
                            } label: {
                                Label("Remove Feed", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .scrollPosition(id: $feedTapIndicatorPosition)
        .onChange(of: mainViewModel.feedsViewModel.selectedTab) { _, newValue in
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
                    FeedsView(oAuthData: oAuthData, model: mainViewModel.feedsViewModel)
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
                FeedsView(oAuthData: oAuthData, model: mainViewModel.feedsViewModel)
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
