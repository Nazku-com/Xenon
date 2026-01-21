//
//  AccountHeaderView.swift
//  xenon
//
//  Created by 김수환 on 12/26/25.
//

import SwiftUI
import EmojiText
import FediverseFeature
import UIComponent

public struct AccountHeaderView: View {
    
    let account: FediverseAccountEntity?
    
    public var body: some View {
        if let account {
            HStack(alignment: .top, spacing: 4) {
                ImageView(url: account.avatar)
                    .clipShape(.circle)
                    .frame(width: 32)
                VStack(alignment: .leading) {
                    let emojis = account.emojis.toRemoteEmojies
                    EmojiText(markdown: (account.displayName ?? account.username ?? ""), emojis: emojis)
                        .animated(true)
                        .emojiText.size(24)
                        .font(.styled(.subtitle))
                    EmojiText(markdown: account.acct, emojis: emojis)
                        .animated(true)
                        .emojiText.size(24)
                        .font(.styled(.caption, design: .serif))
                }
                
                .minimumScaleFactor(0.4)
                .lineLimit(1)
            }
        } else {
            EmptyView()
        }
    }
}
