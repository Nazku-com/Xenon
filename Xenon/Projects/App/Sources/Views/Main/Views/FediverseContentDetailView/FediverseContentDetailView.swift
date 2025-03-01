//
//  FediverseContentDetailView.swift
//  UIComponent
//
//  Created by 김수환 on 1/28/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import Neumorphic
import UIComponent
import FediverseFeature

public struct FediverseContentDetailView: View {
    
    @ObservedObject var model: FediverseContentDetailViewModel
    
    public var body: some View {
        ScrollView {
            ForEach(model.contents, id: \.id) { content in
                ContentCellView(content: content, contentLineLimit: nil) {
                    buttonView(content: content)
                } onAvatarTapped: { account in
                    NotificationCenter.default.post(name: .NeedNavigationNotification, object: account)
                }
            }
        }
        .background(Color.Neumorphic.main)
        .onFirstAppear {
            Task {
                await model.fetch(fromBottom: false) // TODO: - need refresh navigatedContent too
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .NeedRefreshFediverseResponse)) { output in
            didRecieveNeedRefreshFediverseResponse(output)
        }
    }
    
    @ViewBuilder
    private func buttonView(content: FediverseResponseEntity) -> some View {
        HStack(spacing: 20) {
            Spacer()
            
            VStack {
                Text(SuffixNumber.format(content.reblogsCount))
                Button {
                    self.boostAction(content: content)
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(content.reblogged ? .red : .gray)
                        .frame(height: 16)
                }
                .softButtonStyle(Circle(), padding: 8)
            }
            
            VStack {
                Text(SuffixNumber.format(content.favouritesCount))
                Button {
                    self.likeAction(content: content)
                } label: {
                    Image(systemName: content.favourited ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(content.favourited ? .red : .gray)
                        .frame(height: 16)
                }
                .softButtonStyle(Circle(), padding: 8)
            }
            .padding(.trailing, 8)
        }
        .font(DesignFont.Default.Bold.extraSmall)
    }
    
    private func boostAction(content: FediverseResponseEntity) { // TODO: -
        Task { @MainActor in
            guard let oAuthData = OAuthDataManager.shared.currentOAuthData
            else {
                return
            }
            let result = content.reblogged
            ? await oAuthData.unboost(from: content.id)
            : await oAuthData.boost(to: content.id)
            switch result {
            case .success(let response):
                for index in model.contents.indices {
                    if model.contents[index].id == response.id {
                        model.contents[index] = response
                        return
                    }
                    if model.contents[index].id == response.reblog?.id {
                        guard let reblogContent = response.reblog else { return }
                        model.contents[index] = reblogContent
                        return
                    }
                }
            case .failure:
                print("failure")
                return // TODO: -
            }
        }
    }
    
    private func likeAction(content: FediverseResponseEntity) {
        Task { @MainActor in
            guard let oAuthData = OAuthDataManager.shared.currentOAuthData
            else {
                return
            }
            guard let result = content.favourited
                    ? await oAuthData.removeReaction(from: content.id)
                    : await oAuthData.createReaction(to: content.id)
            else {
                return
            }
            NotificationCenter.default.post(name: .NeedRefreshFediverseResponse, object: result)
        }
    }
    
    func didRecieveNeedRefreshFediverseResponse(_ notification: Notification) {
        guard let entity = notification.object as? FediverseResponseEntity else { return }
        if let index = model.contents.firstIndex(where: { $0.id == entity.id }) {
            model.contents[index] = entity
        }
    }
}
