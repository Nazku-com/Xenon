//
//  Mention.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO {
    
    struct Mention: NetworkingDTOType, Hashable {
        /// Account ID.
        public let id: String
        /// The username of the account.
        public let username: String
        /// Equals username for local users, includes @domain for remote ones.
        public let acct: String
        /// URL of user's profile (can be remote).
        public let url: String?
        
        public func toEntity() async throws -> FediverseResponseEntity.Mention {
            .init(
                id: id,
                username: username,
                acct: acct,
                url: url ?? ""
            )
        }
    }
}
