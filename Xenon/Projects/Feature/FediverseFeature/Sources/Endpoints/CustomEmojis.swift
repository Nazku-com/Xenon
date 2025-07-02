//
//  CustomEmojis.swift
//  FediverseFeature
//
//  Created by 김수환 on 3/16/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature

public extension OauthData {
    
    func customEmojis() async -> Result<[String: [CustomEmojiEntity]], NetworkingServiceError> {
        switch nodeType {
        case .mastodon, .mastodonCompatible, .hollo:
            let result = await NetworkingService().request(api: MastodonAPI.customEmojis(from: url, token: token))
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode([CustomEmojiDTO].self, from: data)
                    return .success(result.toEntity().toDictionary)
                } catch (let error) {
                    return .failure(.jsonParsingFailed(error))
                }
            case .failure(let failure):
                return .failure(.asError(failure))
            }
        case .misskey:
            return .failure(.networkError("not yet implement"))
        }
    }
}

struct CustomEmojiDTO: Codable {
    
    let shortcode: String
    let url: String
    let static_url: String
    let visible_in_picker: Bool
    let category: String?
}

extension [CustomEmojiDTO] {
    
    func toEntity() -> [CustomEmojiEntity] {
        let filteredEmojis = self.filter(\.visible_in_picker)
        return filteredEmojis.compactMap { emoji -> CustomEmojiEntity? in
            guard let url = URL(string: emoji.url),
                  let staticUrl = URL(string: emoji.static_url) else {
                return nil
            }
            return CustomEmojiEntity(
                category: emoji.category ?? "",
                shortcode: emoji.shortcode,
                url: url,
                staticUrl: staticUrl
            )
        }
    }
}
public struct CustomEmojiEntity: NetworkingEntityType, Hashable {
    
    public let category: String
    public let shortcode: String
    public let url: URL
    public let staticUrl: URL
}

extension [CustomEmojiEntity] {
    var toDictionary: [String: [CustomEmojiEntity]] {
        Dictionary(grouping: self, by: { $0.category })
    }
}
