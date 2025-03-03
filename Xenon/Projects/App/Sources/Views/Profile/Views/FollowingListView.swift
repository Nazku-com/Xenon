//
//  FollowingListView.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import SwiftUI
import FediverseFeature
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
        let result = await OAuthDataManager.shared.currentOAuthData?.followers(id: userID)
        switch result {
        case .success(let success):
            followerList = success
        case .failure, .none:
            print("error")
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
    }
    
    @ViewBuilder
    private func accountListView(_ contentType: ContentType) -> some View {
        List {
            ForEach(contentType == .follower ? manager.followerList : manager.followingList) { account in
                Text(account.acct)
            }
        }
        .task {
            await manager.fetch(contentType: contentType)
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
