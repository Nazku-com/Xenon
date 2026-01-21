//
//  Mention.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension FediverseResponseEntity {
    
    struct Mention: NetworkingEntityType, Hashable, Equatable {
        /// Account ID.
        public let id: String
        /// The username of the account.
        public let username: String
        /// Equals username for local users, includes @domain for remote ones.
        public let acct: String
        /// URL of user's profile (can be remote).
        public let url: String
    }
}
