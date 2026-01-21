//
//  Visibility.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO {
    
    enum Visibility: String, Codable, Sendable {
        /// The status message is public.
        /// - Visible on Profile: Anyone incl. anonymous viewers.
        /// - Visible on Public Timeline: Yes.
        /// - Federates to other instances: Yes.
        case `public`
        /// The status message is unlisted.
        /// - Visible on Profile: Anyone incl. anonymous viewers.
        /// - Visible on Public Timeline: No.
        /// - Federates to other instances: Yes.
        case unlisted
        /// The status message is private.
        /// - Visible on Profile: Followers only.
        /// - Visible on Public Timeline: No.
        /// - Federates to other instances: Only remote @mentions.
        case `private`
        /// The status message is direct.
        /// - Visible on Profile: No.
        /// - Visible on Public Timeline: No.
        /// - Federates to other instances: Only remote @mentions.
        case direct
        
        var toFediverseVisibility: FediverseResponseEntity.Visibility {
            switch self {
            case .public:
                    .public
            case .unlisted:
                    .unlisted
            case .private:
                    .private
            case .direct:
                    .direct
            }
        }
    }
}
