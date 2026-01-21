//
//  FollowingListView.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import SwiftUI
import FediverseFeature
import EmojiText
import UIComponent

struct FollowingListView: View {
    
    @State var selectedContent: String
    @ObservedObject private var manager: FollowingListManager
    @Environment(RouterPath.self) private var routerPath
    
    var body: some View {
        VStack {
            SegmentedControl(contentList: ContentType.allCases.compactMap({ $0.rawValue }), selectedContent: $selectedContent)
            TabView(selection: $selectedContent) {
                ForEach(ContentType.allCases, id:\.self) { contentType in
                    accountListView(contentType)
                        .tag(contentType.rawValue)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Color.Neumorphic.main)
    }
    
    @ViewBuilder
    private func accountListView(_ contentType: ContentType) -> some View {
        List {
            ForEach(manager.followRequestList) { account in
                accountCell(user: account, isFollowRequested: true)
                    .listRowBackground(Color.clear)
            }
            ForEach(contentType == .follower ? manager.followerList : manager.followingList) { account in
                accountCell(user: account)
                    .listRowBackground(Color.clear)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .refreshable {
            Task {
                await manager.fetch(contentType: contentType)
            }
        }
        .task {
            let numberOfContents: Int = {
                switch contentType {
                case .following:
                    manager.followingList.count
                case .follower:
                    manager.followerList.count
                }
            }()
            if numberOfContents == 0 {
                await manager.fetch(contentType: contentType)
            }
        }
    }
    
    @ViewBuilder
    private func accountCell(user: FediverseAccountEntity, isFollowRequested: Bool = false) -> some View {
        HStack(alignment: .top, spacing: 12) {
            KFImageView(
                user.avatar,
                blurHash: user.avatarBlurhash,
                height: 42,
                aspect: 1
            )
            .frame(width: 42, height: 42)
            .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 4) {
                let name = user.displayName ?? user.username
                HtmlText(rawHtml: name, emojis: user.emojis.toRemoteEmojis, emojiSize: DesignFont.FontSize.normal)
                    .font(DesignFont.Rounded.Bold.normal)
                Text(user.acct)
                    .font(DesignFont.Default.Medium.extraSmall)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
            Spacer()
        }
        .onTapGesture {
            routerPath.path.append(NavigationType.userAccountInfo(user))
        }
        .overlay(alignment: .trailing) {
            if isFollowRequested {
                Button {
                    Task {
                        await manager.acceptFollow(id: user.id)
                    }
                } label: {
                    if manager.RequestingIDs.contains(user.id) {
                        ProgressView()
                    } else {
                        Text("accept")
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    init(selectedContent: ContentType, manager: FollowingListManager) {
        self.selectedContent = selectedContent.rawValue
        self.manager = manager
    }
}

extension FollowingListView {
    
    struct Initializer {
        
        let id: String
        let contentType: ContentType
    }
    
    enum ContentType: String, CaseIterable {
        
        case following
        case follower
    }
}

#Preview {
    FollowingListView(selectedContent: .follower, manager: .init(userID: ""))
}
