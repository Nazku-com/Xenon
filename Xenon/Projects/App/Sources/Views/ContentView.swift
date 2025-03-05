import SwiftUI
import UIComponent
import FediverseFeature
import EmojiText

public struct ContentView: View {
    
    let oAuthData: OauthData
    @State var selectedTab = MainTab.home.rawValue
    @State var path = NavigationPath()
    @State var navigationBarModel = NavigationBarModel()
    @ObservedObject private var contentViewModel = ContentViewModel.shared
    
    public var body: some View {
        VStack {
            SideBarView(model: SideBarViewModel.shared) {
                SideBarDisplayView(path: $path, oAuthData: oAuthData)
            } content: {
                VStack(spacing: 0) {
                    navigationStackView
                    NavigationBarView(path: $path, navigationBarModel: $navigationBarModel)
                }
                .onReceive(navigationBarModel.buttonTapPublisher) { buttonType in
                    switch buttonType {
                    case .home, .search, .message:
                        if let tabName = MainTab(rawValue: buttonType.rawValue) {
                            if selectedTab == tabName.rawValue {
                                PathManager.shared.updateTab(tabName, path: .init())
                            } else {
                                selectedTab = tabName.rawValue
                                PathManager.shared.updateTab(tabName, path: path)
                            }
                        }
                        path = PathManager.shared.path
                    case .plus:
                        NavigationBarViewModel.shared.isAddNoteBarViewShown = true
                        return
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .NeedNavigationNotification)) { notification in
                    path.append(notification)
                }
                .environment(\.openURL, OpenURLAction { url in
                    let destination = URLHandler.shared.checkDestination(url)
                    path.append(destination)
                    return .handled
                })
                .onOpenURL { _ in }
            }
        }
        .background(Color.Neumorphic.main)
        .onChange(of: OAuthDataManager.shared.oAuthDatas) { _, _ in
            path = .init()
        }
        .fullScreenCover(isPresented: $contentViewModel.isSheetPresented) {
            FullScreenCoverView(contentType: $contentViewModel.selectedSheet)
        }
    }
    
    @ViewBuilder
    private var navigationStackView: some View {
        NavigationStack(path: $path) {
            TabView(selection: $selectedTab) {
                ForEach(MainTab.allCases, id: \.self) { content in
                    content.view(
                        oAuthData: oAuthData
                    )
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
            .navigationDestination(for: URLHandler.URLType.self) { urlType in
                destinationView(from: urlType)
            }
            .navigationDestination(for: Notification.self) { notification in
                destinationView(from: notification)
            }
            .navigationDestination(for: NavigationType.self) { notification in
                SideBarViewModel.shared.sideBarOpenPublisher.send(false)
                return destinationView(from: notification)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(from notification: Notification) -> some View {
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
    private func destinationView(from type: NavigationType) -> some View {
        switch type {
        case .userAccountInfo(let fediverseAccountEntity):
            FediverseProfileView(model: .init(oAuthData: oAuthData, fediverseAccountData: fediverseAccountEntity))
        case .userHandle(let handle):
            FediverseProfileView(model: .init(oAuthData: oAuthData, handle: handle))
        case .login:
            LoginView(model: .init())
                .onAppear {
                    navigationBarModel.shrinkBarPublisher.send(true)
                }.onDisappear {
                    navigationBarModel.shrinkBarPublisher.send(false)
                }
        }
    }
    
    @ViewBuilder
    private func destinationView(from urlType: URLHandler.URLType) -> some View {
        switch urlType {
        case .handle(let handle):
            FediverseProfileView(model: .init(oAuthData: oAuthData, handle: handle))
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
                    navigationBarModel.shrinkBarPublisher.send(true)
                }.onDisappear {
                    navigationBarModel.shrinkBarPublisher.send(false)
                }
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
