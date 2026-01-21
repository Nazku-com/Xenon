//
//  Tag.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension FediverseResponseEntity {
    
    struct Tag: NetworkingEntityType, Hashable, Equatable {
        /// The hashtag, not including the preceding #.
        public let name: String
        /// The URL of the hashtag.
        public let url: String
    }
}
