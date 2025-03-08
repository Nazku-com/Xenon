//
//  NotificationListView.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import SwiftUI
import FediverseFeature
import EmojiText
import UIComponent
import Kingfisher

struct NotificationListView: View {
    
    @ObservedObject private var oAuthManager: OAuthDataManager = .shared
    @ObservedObject private var manager = NotificationManager.shared
    
    @State private var selectedTab: String = FediverseNotificationEntity.NotificationType.mention.rawValue
    @Binding var routerPath: RouterPath
    
    var body: some View {
        NavigationStack(path: $routerPath.path) {
            VStack(alignment: .leading) {
                Text("Notifications")
                    .font(DesignFont.Rounded.Bold.extralarge)
                    .padding(.horizontal, 16)
                contentTabView
            }
            .background(Color.Neumorphic.main)
            .onChange(of: oAuthManager.currentOAuthData, { _, _ in
                manager.notifications.removeAll()
                Task {
                    await manager.fetch(fromBottom: false)
                }
            })
            .onFirstAppear {
                Task {
                    AppDelegate.instance.showLoading(true)
                    await manager.fetch(fromBottom: false)
                    AppDelegate.instance.showLoading(false)
                }
            }
            .NavigationDestinations(for: $routerPath)
        }
    }
    
    @ViewBuilder
    private var contentTabView: some View {
        let contentList = FediverseNotificationEntity.NotificationType.usersNotification.compactMap({ $0.rawValue })
        SegmentedControl(contentList: contentList, selectedContent: $selectedTab)
        TabView(selection: $selectedTab) {
            ForEach(FediverseNotificationEntity.NotificationType.usersNotification, id: \.self) { tab in
                listView(notifications: manager.notifications[tab])
                    .tag(tab.rawValue)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    @ViewBuilder
    private func listView(notifications: [FediverseNotificationEntity]?) -> some View {
        List {
            if let notifications,
               !notifications.isEmpty {
                ForEach(notifications) {notification in
                    Button {
                        if let status = notification.status {
                            routerPath.path.append(Notification(name: .NeedNavigationNotification, object: status)) // TODO: -
                        }
                    } label: {
                        notificationCell(notification: notification)
                    }
                    .listRowBackground(Color.clear)
                }
            } else {
                Text("Currently no notifications")
                    .listRowBackground(Color.clear)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .refreshable {
            Task {
                await manager.fetch(fromBottom: false)
            }
        }
    }
    
    @ViewBuilder
    private func notificationCell(notification: FediverseNotificationEntity) -> some View {
        HStack(alignment: .top, spacing: 12) {
            if let sentUser = notification.account {
                Button {
                    routerPath.path.append(Notification(name: .NeedNavigationNotification, object: sentUser)) // TODO: -
                } label: {
                    KFImageView(
                        sentUser.avatar,
                        blurHash: sentUser.avatarBlurhash,
                        height: 42,
                        aspect: 1
                    )
                    .frame(width: 42, height: 42)
                    .clipShape(.circle)
                }
                .softButtonStyle(Circle(), padding: 1)
                
                VStack(alignment: .leading, spacing: 4) {
                    let name = sentUser.displayName ?? sentUser.username
                    HtmlText(rawHtml: name, emojis: sentUser.emojis.toRemoteEmojis, emojiSize: DesignFont.FontSize.normal)
                        .font(DesignFont.Rounded.Bold.normal)
                    Text(sentUser.acct)
                        .font(DesignFont.Default.Medium.extraSmall)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 8)
                    
                    if let status = notification.status {
                        HtmlText(rawHtml: status.content, emojis: status.emojis.toRemoteEmojis)
                    }
                    DateTimeView(date: notification.createdAt)
                }
            }
        }
    }
}

extension FediverseNotificationEntity.NotificationType {
    
    static let usersNotification: [Self] = [.mention, .favourite, .reblog, .follow_request, .follow, .poll]
}
