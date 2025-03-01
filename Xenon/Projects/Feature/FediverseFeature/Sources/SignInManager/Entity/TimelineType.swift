//
//  TimelineType.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation

public enum TimelineType: Equatable, Codable {
    
    case home
    case local
    case hybrid
    case global
    case hashtag(tag: String)
}
