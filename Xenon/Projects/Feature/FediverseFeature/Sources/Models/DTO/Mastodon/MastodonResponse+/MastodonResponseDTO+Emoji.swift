//
//  Emoji.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//


import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO {
    
    final class Emoji: Codable, Sendable {
        /// The shortcode of the emoji
        public let shortcode: String
        /// URL to the emoji static image
        public let staticURL: URL
        /// URL to the emoji image
        public let url: URL
        
        private enum CodingKeys: String, CodingKey {
            case shortcode
            case staticURL = "static_url"
            case url
        }
    }
}

public extension [MastodonResponseDTO.Emoji] {
    var toDictionary: [String: URL] {
        return Dictionary(
            uniqueKeysWithValues: map { ($0.shortcode, $0.url) }
        )
    }
}
