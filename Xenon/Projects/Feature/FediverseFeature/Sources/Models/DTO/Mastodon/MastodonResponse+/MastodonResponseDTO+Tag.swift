//
//  Tag.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO {
    
    struct Tag: NetworkingDTOType, Hashable {
        /// The hashtag, not including the preceding #.
        public let name: String
        /// The URL of the hashtag.
        public let url: String
        
        public func toEntity() async throws -> FediverseResponseEntity.Tag {
            .init(
                name: name,
                url: url
            )
        }
    }
}
