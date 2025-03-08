//
//  FediverseResponesEntity+StaggeredGridContentType.swift
//  xenon
//
//  Created by 김수환 on 2/8/25.
//

import SwiftUI
import FediverseFeature
import UIComponent
import EmojiText

extension FediverseResponseEntity: StaggeredGridContentType {
    
    public func view(routerPath: Environment<RouterPath>) -> some View {
        ContentCellView(content: self, hideContents: !SensitiveContentManager.shared.hideWarning && self.sensitive) {
            HStack {
                Spacer()
                Button {
                    self.likeAction()
                } label: {
                    Image(systemName: self.favourited ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(self.favourited ? .red : .gray)
                        .frame(height: 16)
                }
                .softButtonStyle(Circle(), padding: 8)
            }
        } onAvatarTapped: { account in
            Task { @MainActor in
                routerPath.wrappedValue.path.append(NavigationType.userAccountInfo(account))
            }
        }
    }
    
    public var contextMenu: some View {
        VStack {
            Button {
                self.likeAction()
            } label: {
                Text("like")
            }
        }
    }
    
    public var contentString: String {
        let additionalText: String = {
            guard let content = reblog?.content,
                  let string = content.parseHTML()?.string
            else {
                return ""
            }
            return "\n reblogged: \n \(string)"
        }()
        
        return content + additionalText
    }
    
    private func likeAction() {
        Task { @MainActor [weak self] in
            guard let self,
                  let oAuthData = OAuthDataManager.shared.currentOAuthData
            else {
                return
            }
            guard let result = favourited
                    ? await oAuthData.removeReaction(from: id)
                    : await oAuthData.createReaction(to: id)
            else {
                return
            }
            NotificationCenter.default.post(name: .NeedRefreshFediverseResponse, object: result)
        }
    }
}

extension FediverseResponseEntity: @retroactive ContentType {
    
    public var remoteEmoji: [RemoteEmoji] {
        emojis.toRemoteEmojis
    }
}

extension FediverseResponseEntity.Attachment: @retroactive MediaAttachmentType {
    
    public var contentType: UIComponent.MediaContentType {
        .init(string: type.rawValue) ?? .unknown
    }
}

extension FediverseAccountEntity: @retroactive AccountType {
    
    public var name: String {
        guard let displayName,
              !displayName.isEmpty
        else {
            return username
        }
        return displayName
    }
    
    public var remoteEmoji: [RemoteEmoji] {
        emojis.toRemoteEmojis
    }
}

extension Notification.Name {
    
    static let NeedRefreshFediverseResponse = Notification.Name("NeedRefreshFediverseResponse")
}
