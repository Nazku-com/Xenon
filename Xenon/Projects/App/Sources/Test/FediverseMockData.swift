//
//  FediverseMockData.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import Foundation
import FediverseFeature

struct FediverseMockData {
    
    static let oAuthData: OauthData = .init(
        url: URL(string: "https://xenon.social")!,
        nodeType: .mastodon,
        token: .init(accessToken: "", createdAt: 0),
        user: account
    )
    
    static func fediverseData(count: Int) -> [FediverseResponseEntity] {
        (0...count).compactMap { num in
            FediverseResponseEntity(
                id: "\(num)",
                uri: "\(num)",
                url: nil,
                account: account,
                inReplyToID: nil,
                inReplyToAccountID: nil,
                content: "hello world \(num)",
                createdAt: "2025-01-30T12:34:56.789Z",
                emojis: .init(),
                reblogsCount: 1,
                favouritesCount: 3,
                reblogged: false,
                favourited: false,
                sensitive: false,
                spoilerText: "",
                visibility: .public,
                mediaAttachments: [],
                mentions: [],
                tags: [],
                application: nil,
                language: nil,
                reblog: nil,
                pinned: nil
            )
        }
    }
    
    static let account: FediverseAccountEntity = .init(
        id: "testID",
        username: "testUserName",
        acct: "testUserName@xenon.social",
        displayName: "testDisplayName",
        note: "hello world",
        url: "https://xenon.social",
        avatar: "https://static.xenon.social/hollo/avatars/7496cdf6-bbdd-43a0-97b0-27a8df27de23.png?1738498438496",
        avatarBlurhash: nil,
        header: "https://static.xenon.social/hollo/covers/7496cdf6-bbdd-43a0-97b0-27a8df27de23.png?1738498530307",
        headerBlurhash: nil,
        locked: false,
        createdAt: Date(),
        followersCount: 3,
        followingCount: 4,
        emojis: .init()
    )
}
