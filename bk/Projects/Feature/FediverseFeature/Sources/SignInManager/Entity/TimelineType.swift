//
//  TimelineType.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation

public enum TimelineType: Equatable, Codable, Hashable {
    
    case home
    case local
    case hybrid
    case global
    case hashtag(tag: String)
    
    var asString: String {
        switch self {
        case .home:
            "home"
        case .local:
            "local"
        case .hybrid:
            "hybrid"
        case .global:
            "global"
        case .hashtag:
            "hashtag"
        }
    }
}
