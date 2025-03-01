//
//  MisskeyOauthTokenDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

struct MisskeyOauthTokenDTO: NetworkingDTOType {
    
    public let token: String
    public let user: MisskeyAccountDTO
    
    func toEntity() -> MisskeyOauthTokenEntity {
        .init(
            token: .init(accessToken: token, createdAt: Date().timeIntervalSince1970),
            user: user.toEntity()
        )
    }
}

//    "user\":{
//        "id\":\"9xx0w55u98t70001\",
//        "name\":null,
//        "username\":\"tkgka\",
//        "host\":null,
//        "avatarUrl\":\"https://haze.social/proxy/avatar.webp?url=https%3A%2F%2Fhaze.social%2Ffiles%2F1fc54b56-54cf-4104-9d56-50a976392898&avatar=1\",
//        "avatarBlurhash\":\"eJI??2kr00RjyDngcFNGWXx^0NsS~Boz$f-;RjNG%2M|1jI[?a%NR+\",
//        "avatarDecorations\":[],
//        "isBot\":false,
//        "isCat\":true,
//        "emojis\":{},
//        "onlineStatus\":\"online\",
//        "badgeRoles\":[],
//        "url\":null,
//        "uri\":null,
//        "movedTo\":null,
//        "alsoKnownAs\":null,
//        "createdAt\":\"2024-09-08T10:56:17.442Z\",
//        "updatedAt\":\"2025-01-17T15:20:02.022Z\",
//        "lastFetchedAt\":null,
//        "bannerUrl\":\"https://haze.social/files/webpublic-a859017e-1554-438e-9781-ce75f6b8e653\",
//        "bannerBlurhash\":\"e88XIbS[.T4m9^%3%MRoNGIo9ur]MvnNwdtSX9ouV?RiMdthVttRRl\",
//        "isLocked\":false,
//        "isSilenced\":false,
//        "isSuspended\":false,
//        "description\":\"Hello world\",
//        "location\":null,
//        "birthday\":null,
//        "lang\":null,
//        "fields\":[],
//        "verifiedLinks\":[],
//        "followersCount\":4,
//        "followingCount\":4,
//        "notesCount\":36,
//        "pinnedNoteIds\":[],
//        "pinnedNotes\":[],
//        "pinnedPageId\":null,
//        "pinnedPage\":null,
//        "publicReactions\":true,
//        "followersVisibility\":\"public\",
//        "followingVisibility\":\"public\",
//        "twoFactorEnabled\":false,
//        "usePasswordLessLogin\":false,
//        "securityKeys\":false,
//        "roles\":[],
//        "memo\":null
//    }
