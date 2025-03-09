//
//  FediverseProfileViewModel.swift
//  xenon
//
//  Created by 김수환 on 2/7/25.
//

import SwiftUI
import UIComponent
import FediverseFeature

final class FediverseProfileViewModel: FetchableModelType {
    
    let oAuthData: OauthData
    let handle: String
    @Published var fediverseAccountData: FediverseAccountEntity
    @Published var isLoading: Bool = false
    @Published var followState: FollowState = .unknown
    
    @MainActor
    public func fetch(fromBottom: Bool) async { // TODO: -
        guard !isLoading else { return }
        isLoading = true
        followState = .loading
        let result = await oAuthData.relationships(id: fediverseAccountData.id)
        switch result {
        case .success(let relationships):
            guard let relationship = relationships.first else {
                followState = .unknown
                return
            }
            updateFollowState(with: relationship)
        case .failure(let error):
            followState = .unknown
            print(error)
        }
        isLoading = false
    }
    
    @MainActor
    public func unfollowUser() async {
        guard !isLoading
        else {
            return
        }
        let userId = fediverseAccountData.id
        isLoading = true
        followState = .loading
        
        let result = await oAuthData.unfollow(id: userId)
        switch result {
        case .success(let relationship):
            updateFollowState(with: relationship)
        case .failure(let error):
            followState = .unknown
            print(error)
        }
        
        isLoading = false
    }
    
    @MainActor
    public func followUser() async {
        guard !isLoading
        else {
            return
        }
        let userId = fediverseAccountData.id
        isLoading = true
        followState = .loading
        
        let result = await oAuthData.follow(id: userId)
        switch result {
        case .success(let relationship):
            updateFollowState(with: relationship)
        case .failure(let error):
            followState = .unknown
            print(error)
        }
        
        isLoading = false
    }
    
    private func updateFollowState(with relationship: FediverseRelationship) {
        if relationship.following {
            followState = .following
        } else {
            if relationship.requested {
                followState = .requested
            } else {
                followState = .notFollowing
            }
        }
    }
    
    init(
        oAuthData: OauthData,
        fediverseAccountData: FediverseAccountEntity
    ) {
        self.oAuthData = oAuthData
        self.handle = fediverseAccountData.acct
        self.fediverseAccountData = fediverseAccountData
    }
    
    enum FollowState {
        
        case following
        case notFollowing
        case requested
        case loading
        case unknown
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .following:
                Text("following")
            case .notFollowing:
                Text("follow")
            case .requested:
                Text("requested")
            case .loading:
                ProgressView()
                    .frame(width: 40)
            case .unknown:
                Text("unknown")
            }
        }
    }
}
