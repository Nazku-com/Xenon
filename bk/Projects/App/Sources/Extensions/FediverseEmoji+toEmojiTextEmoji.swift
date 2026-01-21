//
//  FediverseEmoji+toEmojiTextEmoji.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import Foundation
import FediverseFeature
import EmojiText

extension Emojis {
    var toRemoteEmojis: [RemoteEmoji] {
        compactMap { key, value -> RemoteEmoji in
                .init(shortcode: key, url: value)
        }
    }
}
