import SwiftUI
import UIComponent
import FediverseFeature
import EmojiText

public struct ContentView: View {
    
    let oAuthData: OauthData
    @ObservedObject var model = ContentViewModel()
    @State var navigationBarModel = NavigationBarModel.shared
    @State var homeRouterPath = RouterPath()
    @State var messageRouterPath = RouterPath()
    
    public var body: some View {
        VStack {
            SideBarView(model: SideBarViewModel.shared) {
                SideBarDisplayView(oAuthData: oAuthData)
            } content: {
                VStack(spacing: 0) {
                    navigationStackView
                    NavigationBarView(navigationBarModel: $navigationBarModel)
                }
                .onReceive(navigationBarModel.buttonTapPublisher) { buttonType in
                    switch buttonType {
                    case .home, .search, .message:
                        if model.selectedTab == buttonType.rawValue {
                            if buttonType == .home {
                                homeRouterPath.path = .init()
                            } else {
                                messageRouterPath.path = .init()
                            }
                            return
                        }
                        model.selectedTab = buttonType.rawValue
                        return
                    case .plus:
                        model.isSheetPresented = true
                    }
                }
            }
        }
        .background(Color.Neumorphic.main)
        .onReceive(NotificationCenter.default.publisher(for: .NeedNavigationNotification)) { notification in
            SideBarViewModel.shared.sideBarOpenPublisher.send(false)
            if model.selectedTab == MainTab.home.rawValue {
                homeRouterPath.path.append(notification)
            } else {
                messageRouterPath.path.append(notification)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .showLoginScreen)) { _ in
            SideBarViewModel.shared.sideBarOpenPublisher.send(false)
            if model.selectedTab == MainTab.home.rawValue {
                homeRouterPath.path.append(NavigationType.login)
            } else {
                messageRouterPath.path.append(NavigationType.login)
            }
        }
        .onChange(of: OAuthDataManager.shared.currentOAuthData) { _, _ in
            homeRouterPath.path = .init()
            messageRouterPath.path = .init()
        }
        .environment(\.openURL, OpenURLAction { url in
            Task { @MainActor in
                AppDelegate.instance.showLoading(true)
                let destination = await URLHandler.shared.checkDestination(url)
                if model.selectedTab == MainTab.home.rawValue {
                    homeRouterPath.path.append(NavigationType.url(destination))
                } else {
                    messageRouterPath.path.append(NavigationType.url(destination))
                }
                AppDelegate.instance.showLoading(false)
            }
            return .handled
        })
        .onOpenURL { _ in }
        .sheet(isPresented: $model.isSheetPresented) {
            AddNoteBarView(isPresented: $model.isSheetPresented)
        }
    }
    
    @ViewBuilder
    private var navigationStackView: some View {
        TabView(selection: $model.selectedTab) {
            ForEach(MainTab.allCases, id: \.self) { content in
                view(for: content)
                    .toolbar(.hidden, for: .tabBar)
                    .tag(content.rawValue)
            }
        }
        .onAppear {
            SideBarViewModel.shared.sideBarOpenablePublisher.send(true)
        }
        .onDisappear {
            SideBarViewModel.shared.sideBarOpenablePublisher.send(false)
        }
    }
    
    
    @ViewBuilder
    func view(
        for mainTab: MainTab
    ) -> some View {
        switch mainTab {
        case .home:
            MainView(model: .init(oAuthData: oAuthData), routerPath: $homeRouterPath)
        case .search:
            Text("search") // TODO: -
        case .message:
            NotificationListView(routerPath: $messageRouterPath)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            oAuthData: FediverseMockData.oAuthData
        )
    }
}
