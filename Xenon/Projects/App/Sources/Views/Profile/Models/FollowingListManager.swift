//
//  FollowingListManager.swift
//  xenon
//
//  Created by 김수환 on 3/5/25.
//

import Foundation
import FediverseFeature

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
