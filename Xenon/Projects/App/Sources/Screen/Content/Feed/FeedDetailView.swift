//
//  FeedDetailView.swift
//  xenon
//
//  Created by 김수환 on 12/18/25.
//

import SwiftUI
import EmojiText
import UIComponent
import FediverseFeature

@Observable
@MainActor
final class FeedDetailViewModel {
    
    // MARK: - Interface
    
    func fetch() {
        Task {
            let result = await oAuthData?.context(for: content.id)
            switch result {
            case .success(let success):
                contents.insert(contentsOf: success.data.ancestors, at: 0)
                contents.append(contentsOf: success.data.descendants)
                anchorID = content.id
            case .failure(let failure):
                print(failure)
            case .none:
                print("asdf")
            }
        }
    }
    
    var contents: [FediverseResponseEntity] = []
    
    // MARK: - Attribute
    
    var anchorID: String?
    
    @ObservationIgnored private let content: FediverseResponseEntity
    @ObservationIgnored private let oAuthData: OauthData?
    
    // MARK: - Initialization
    
    init(content: FediverseResponseEntity, oAuthData: OauthData?) {
        self.content = content
        self.oAuthData = oAuthData
        contents = [content]
    }
}

struct FeedDetailView: View {
    @Environment(MainViewModel.self) private var mainViewModel
    @State var model: FeedDetailViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.contents) { content in
                    FeedCell(content: content).cellComponent
                }
            }
            .padding(.horizontal, 8)
        }
        .scrollPosition(id: $model.anchorID, anchor: .top)
        .task {
            model.fetch()
        }
    }
    
    // MARK: - Initialization
    
    init(content: FediverseResponseEntity, oAuthData: OauthData?) {
        self.model = .init(content: content, oAuthData: oAuthData)
    }
}

public extension Emojis { // TODO: - Move
    
    var toRemoteEmojies: [RemoteEmoji] {
        self.map { RemoteEmoji(shortcode: $0.key, url: $0.value) }
    }
}
