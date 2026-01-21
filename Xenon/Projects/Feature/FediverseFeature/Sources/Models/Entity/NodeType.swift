//
//  NodeType.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation

public enum NodeType: String, Codable {
    
    case mastodon
    case mastodonCompatible
    case hollo
    case misskey
}
