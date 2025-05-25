//
//  AccountDetail.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/2/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func accountDetail( /// specific user's Contents
        id: String,
        contentType: ContentType,
        minID: String? = nil,
        maxID: String? = nil
    ) async -> Result<[FediverseResponseEntity], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            var datas = contentType.accountDataStatus
            if let minID {
                datas.minID = minID
            }
            if let maxID {
                datas.maxID = maxID
            }
            let data = await NetworkingService().request(
                api: MastodonAPI.accountStatus(from: url, token: token, id: id, data: datas),
                dtoType: [MastodonResponseDTO].self
            )
            
            return data
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
    
    enum ContentType {
        
        case post
        case reply
        case media
        case reblog
        
        var accountDataStatus: AccountStatusData {
            switch self {
            case .post:
                    .init(onlyMedia: false, excludeReplies: true, excludeReblogs: true, pinned: false, minID: nil, maxID: nil)
            case .reply:
                    .init(onlyMedia: false, excludeReplies: false, excludeReblogs: true, pinned: false, minID: nil, maxID: nil) // TODO: -
            case .media:
                    .init(onlyMedia: true, excludeReplies: true, excludeReblogs: true, pinned: false, minID: nil, maxID: nil)
            case .reblog:
                    .init(onlyMedia: false, excludeReplies: true, excludeReblogs: false, pinned: false, minID: nil, maxID: nil)
            }
        }
    }
}
