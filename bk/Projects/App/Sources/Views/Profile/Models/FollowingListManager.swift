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
    @Published var followRequestList: [FediverseAccountEntity] = []
    @Published var RequestingIDs: [String] = []
    
    @Published var isLoading: Bool = false {
        didSet {
            AppDelegate.instance.showLoading(isLoading)
        }
    }
    
    @MainActor
    func acceptFollow(id: String) async {
        defer {
            RequestingIDs.removeAll(where: { $0 == id })
        }
        RequestingIDs.append(id)
        let result = await OAuthDataManager.shared.currentOAuthData?.acceptFollow(id: id)
        switch result {
        case .success:
            guard let follower = followRequestList.first(where: { $0.id == id }) else { return }
            followRequestList.removeAll(where: { $0 == follower })
            followerList.append(follower)
        case .failure, .none:
            return
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
            async let result = OAuthDataManager.shared.currentOAuthData?.followers(id: userID)
            async let followRequestResult = OAuthDataManager.shared.currentOAuthData?.followRequest()
            switch await followRequestResult {
            case .success(let success):
                followRequestList = success
            case .failure, .none:
                print("error")
            }
            switch await result {
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
