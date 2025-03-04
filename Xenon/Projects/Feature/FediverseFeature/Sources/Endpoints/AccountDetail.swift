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
    
    func accountDetail(
        id: String,
        minID: String? = nil,
        maxID: String? = nil
    ) async -> Result<[FediverseResponseEntity], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let data = await NetworkingService().request(
                api: MastodonAPI.accountStatus(from: url, token: token, id: id, data: .init(
                    onlyMedia: false,
                    excludeReplies: false,
                    excludeReblogs: false,
                    pinned: false,
                    minID: minID,
                    maxID: maxID
                )),
                dtoType: [MastodonResponseDTO].self
            )
            
            return data
            
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
}
