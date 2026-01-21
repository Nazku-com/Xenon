//
//  FeedCell.swift
//  xenon
//
//  Created by 김수환 on 12/28/25.
//

import SwiftUI
import UIComponent
import EmojiText
import FediverseFeature

struct FeedCell: View {
    
    @Namespace private var namespace
    @Environment(MainViewModel.self) private var mainViewModel
    let content: FediverseResponseEntity
    
    @State private var isPresented: Bool = false
    var body: some View {
        cellComponent
            .matchedTransitionSource(id: "sheet", in: namespace)
            .onTapGesture {
                isPresented = true
            }
            .fullScreenCover(isPresented: $isPresented) {
                FeedDetailView(content: content, oAuthData: mainViewModel.currentOAuthData)
                    .navigationTransition(.zoom(sourceID: "sheet", in: namespace))
            }
    }
    
    @ViewBuilder
    var cellComponent: some View {
        ContentCell(
            content: content.content,
            date: content.createdAt,
            buttons: [
                .init(title: "reply", image: Image(systemName: "arrowshape.turn.up.backward"), action: {}),
                .init(title: "boost", image: Image(systemName: "arrow.trianglehead.2.clockwise"), action: {}),
                .init(title: "like", image: Image(systemName: "star"), action: {}),
                .init(title: "share", image: Image(systemName: "square.and.arrow.up"), action: {}),
            ],
            emojis: content.emojis.toRemoteEmojies,
            header: {
                AccountHeaderView(account: content.account)
                    .onTapGesture {
                        if let url = content.account.url {
                            mainViewModel.output.send(.openURL(url))
                        }
                    }
            },
            extraContents: {
                edditionalContents(content)
            }
        )
        .padding(.horizontal, 4)
    }
    
    @ViewBuilder
    private func edditionalContents(_ content: FediverseResponseEntity) -> some View {
        VStack(spacing: 8) {
            linkPreviews(content.attachedURLs)
            tagsView(content.tags)
        }
    }
    
    @ViewBuilder
    private func linkPreviews(_ urls: [URL]) -> some View {
        if !urls.isEmpty {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(urls, id:\.self) {
                        LinkPreview(url: $0)
                    }
                }
            }
            .scrollIndicators(.hidden)
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func tagsView(_ tags: [FediverseResponseEntity.Tag]) -> some View {
        if !tags.isEmpty {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 4) {
                    ForEach(tags, id: \.self) { tag in
                        Text("#\(tag.name)") // TODO: - Navigate To URL when Press
                            .font(.styled(.caption))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 6)
                            .foregroundStyle(.blue)
                            .background(.blue.opacity(0.4))
                            .clipShape(.capsule)
                    }
                }
            }
            .frame(height: 18)
            .scrollIndicators(.hidden)
        } else {
            EmptyView()
        }
    }
}
