//
//  NotificationView.swift
//  xenon
//
//  Created by 김수환 on 2/12/25.
//

import SwiftUI
import FediverseFeature
import EmojiText
import UIComponent

struct NotificationView: View {
    
    let oAuthData: OauthData
    
    @Binding var path: NavigationPath
    @State var notifications = [FediverseNotificationEntity]()
    @State var anchorID: String?
    var body: some View {
        VStack {
            notificationsView
        }
        .background(Color.Neumorphic.main.ignoresSafeArea())
        .onChange(of: oAuthData, { _, _ in
            Task { @MainActor in
                await fetchNotifications()
            }
        })
        .onFirstAppear {
            Task { @MainActor in
                await fetchNotifications()
            }
        }
    }
    
    private func fetchNotifications() async {
        notifications.removeAll()
        let result = await oAuthData.notifications()
        switch result {
        case .success(let notifications):
            self.notifications = notifications
        case .failure:
            print("Error Occurs to fetch notifications")
        }
    }
    
    @ViewBuilder
    private var notificationsView: some View {
        ScrollView {
            LazyVStack(spacing: 16) { // TODO: - Maybe use grid?
                ForEach(notifications) { notification in
                    notificationCell(notification: notification)
                        .padding(8)
                        .background {
                            NeumorphicBackgroundView()
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollPosition(id: $anchorID, anchor: .top)
        .refreshable {
            let id = notifications.first?.id
            let result = await oAuthData.notifications(minID: id)
            switch result {
            case .success(let success):
                notifications.insert(contentsOf: success, at: 0)
                anchorID = id
            case .failure:
                print("Error Occurs to fetch notifications")
            }
        }
    }
    
    @ViewBuilder
    private func notificationCell(notification: FediverseNotificationEntity) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(notification.type.rawValue)
                .font(DesignFont.Default.Medium.extraSmall)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background {
                    NeumorphicBackgroundView(isInnerShadowEnabled: true, shape: .capsule)
                }
            HStack(alignment: .top) {
                if let sentUser = notification.account {
                    Button {
                        path.append(NavigationType.userAccountInfo(sentUser))
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
                        EmojiText(name, emojis: sentUser.emojis.toRemoteEmojis)
                            .emojiText.size(DesignFont.FontSize.normal - 4)
                            .font(DesignFont.Rounded.Bold.normal)
                        Text(sentUser.acct)
                            .font(DesignFont.Default.Medium.extraSmall)
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 8)
                        
                        if let status = notification.status {
                            HtmlText(rawHtml: status.content, emojis: status.emojis.toRemoteEmojis)
                        }
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            let isLast = notification.id == notifications.last?.id ?? ""
            if isLast {
                Task { @MainActor in
                    let id = notification.id
                    let result = await oAuthData.notifications(maxID: id)
                    switch result {
                    case .success(let success):
                        notifications.append(contentsOf: success)
                        anchorID = id
                    case .failure:
                        print("Error Occurs to fetch notifications")
                    }
                }
            }
        }
    }
}
