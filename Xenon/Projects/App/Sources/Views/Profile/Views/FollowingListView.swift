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

final class FollowingListManager: ObservableObject {
    
    @Published var followingList: [FediverseAccountEntity] = []
    @Published var followerList: [FediverseAccountEntity] = []
    
    @Published var isLoading: Bool = false {
        didSet {
            AppDelegate.instance.showLoading(isLoading)
        }
    }
    
    @MainActor
    func fetch(contentType: FollowingListView.ContentType) async {
        guard !isLoading else { return }
        isLoading = true
        switch contentType {
        case .following:
            let result = await OAuthDataManager.shared.currentOAuthData?.following(id: userID)
            switch result {
            case .success(let success):
                followingList = success
            case .failure, .none:
                print("error")
            }
        case .follower:
            let result = await OAuthDataManager.shared.currentOAuthData?.followers(id: userID)
            switch result {
            case .success(let success):
                followerList = success
            case .failure, .none:
                print("error")
            }
        }
        isLoading = false
    }
    
    private let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
}

struct FollowingListView: View {
    
    @State var selectedContent: String
    
    @ObservedObject private var manager: FollowingListManager
    
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
            ForEach(contentType == .follower ? manager.followerList : manager.followingList) { account in
                accountCell(user: account)
                    .listRowBackground(Color.clear)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .task {
            await manager.fetch(contentType: contentType)
        }
    }
    
    @ViewBuilder
    private func accountCell(user: FediverseAccountEntity) -> some View {
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
                EmojiText(name, emojis: user.emojis.toRemoteEmojis)
                    .emojiText.size(DesignFont.FontSize.normal - 4)
                    .font(DesignFont.Rounded.Bold.normal)
                Text(user.acct)
                    .font(DesignFont.Default.Medium.extraSmall)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
        }
        .onTapGesture {
            NotificationCenter.default.post(name: .NeedNavigationNotification, object: user)
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
