//
//  Application.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO {
    
    struct Application: NetworkingDTOType, Hashable {
        /// Name of the app.
        public let name: String
        /// Homepage URL of the app.
        public let website: String?
        
        public func toEntity() async throws -> FediverseResponseEntity.Application {
            .init(
                name: name,
                website: website
            )
        }
    }
}
