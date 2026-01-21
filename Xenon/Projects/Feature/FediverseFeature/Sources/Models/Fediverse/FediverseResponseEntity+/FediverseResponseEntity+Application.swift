//
//  Application.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension FediverseResponseEntity {
    
    struct Application: NetworkingEntityType, Hashable, Equatable {
        /// Name of the app.
        public let name: String
        /// Homepage URL of the app.
        public let website: String?
    }
}
