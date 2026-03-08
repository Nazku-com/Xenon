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
import NetworkingFeature

struct FeedCell: View {

    @Namespace private var namespace
    @Environment(MainViewModel.self) private var mainViewModel
    let content: FediverseResponseEntity

    @State private var isPresented: Bool = false
    @State private var isReplyPresented: Bool = false
    @State private var isFavourited: Bool = false
    @State private var favouriteCount: Int = 0
    @State private var isReblogged: Bool = false
    @State private var reblogCount: Int = 0
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
            .sheet(isPresented: $isReplyPresented) {
                ReplyComposeView(
                    replyTo: content,
                    oAuthData: mainViewModel.currentOAuthData
                )
            }
            .onAppear {
                isFavourited = content.favourited
                favouriteCount = content.favouritesCount
                isReblogged = content.reblogged
                reblogCount = content.reblogsCount
            }
    }
    
    @ViewBuilder
    var cellComponent: some View {
        ContentCell(
            content: content.content,
            date: content.createdAt,
            buttons: [
                .init(title: "reply", image: Image(systemName: "arrowshape.turn.up.backward"), action: {
                    isReplyPresented = true
                }),
                .init(
                    title: "\(reblogCount)",
                    image: Image(systemName: isReblogged ? "arrow.trianglehead.2.clockwise.rotate.90" : "arrow.trianglehead.2.clockwise"),
                    action: { toggleReblog() }
                ),
                .init(
                    title: "\(favouriteCount)",
                    image: Image(systemName: isFavourited ? "star.fill" : "star"),
                    action: { toggleFavourite() }
                ),
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
    
    private func toggleReblog() {
        guard let oAuthData = mainViewModel.currentOAuthData else { return }
        let currentState = isReblogged
        isReblogged.toggle()
        reblogCount += currentState ? -1 : 1
        Task {
            let result: Result<(data: FediverseResponseEntity, urlResponse: URLResponse), NetworkingServiceError>
            if currentState {
                result = await oAuthData.unreblog(id: content.id)
            } else {
                result = await oAuthData.reblog(id: content.id)
            }
            switch result {
            case .success(let success):
                isReblogged = success.data.reblogged
                reblogCount = success.data.reblogsCount
            case .failure:
                isReblogged = currentState
                reblogCount += currentState ? 1 : -1
            }
        }
    }

    private func toggleFavourite() {
        guard let oAuthData = mainViewModel.currentOAuthData else { return }
        let currentState = isFavourited
        isFavourited.toggle()
        favouriteCount += currentState ? -1 : 1
        Task {
            let result: Result<(data: FediverseResponseEntity, urlResponse: URLResponse), NetworkingServiceError>
            if currentState {
                result = await oAuthData.unfavourite(id: content.id)
            } else {
                result = await oAuthData.favourite(id: content.id)
            }
            switch result {
            case .success(let success):
                isFavourited = success.data.favourited
                favouriteCount = success.data.favouritesCount
            case .failure:
                isFavourited = currentState
                favouriteCount += currentState ? 1 : -1
            }
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
