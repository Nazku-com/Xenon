//
//  SideBarDisplayView.swift
//  xenon
//
//  Created by 김수환 on 2/5/25.
//

import SwiftUI
import FediverseFeature
import UIComponent
import EmojiText
import Kingfisher

struct SideBarDisplayView: View {
    
    @Binding var path: NavigationPath
    @ObservedObject var model = SideBarDisplayViewModel()
    let oAuthData: OauthData
    
    var body: some View {
        VStack(alignment: .leading) {
            if let user = oAuthData.user {
                HStack {
                    Button {
                        path.append(NavigationType.userAccountInfo(user))
                    } label: {
                        KFImage(user.avatar)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 42, height: 42)
                            .clipShape(.circle)
                    }
                    .softButtonStyle(Circle(), padding: 1)
                    
                    Spacer()
                    
                    Button {
                        model.selectedSheet = .identifier
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    .softButtonStyle(Circle(), padding: 1)
                }
                userInfoView(oAuthData: oAuthData)
                followAndFollowerView(user: user)
                buttonsView
                Spacer()
                Button {
                    model.selectedSheet = .setting
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .softButtonStyle(Circle(), padding: 1)
                .padding(.leading, 16)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.Neumorphic.main)
        .onFirstAppear {
            OAuthDataManager.shared.fetchCurrentUserInfo()
        }
        .sheet(isPresented: $model.isSheetPresented) {
            sheetView
                .presentationDragIndicator(.visible)
        }
    }
    
    @ViewBuilder
    private var sheetView: some View {
        switch model.selectedSheet {
        case .identifier:
            accountsView
                .presentationDetents([
                    .medium, // 중간 높이
                ])
        case .setting:
            SettingsView()
        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var accountsView: some View {
        VStack(spacing: 0) {
            Text("Account")
                .font(DesignFont.Rounded.Bold.large)
                .padding(.top, 16)
            List {
                ForEach(OAuthDataManager.shared.oAuthDatas) { oAuthData in
                    if let user = oAuthData.user {
                        Button {
                            model.selectedSheet = nil
                            SideBarViewModel.shared.sideBarOpenPublisher.send(false)
                            OAuthDataManager.shared.currentOAuthData = oAuthData
                        } label: {
                            HStack {
                                KFImageView(
                                    user.avatar,
                                    blurHash: user.avatarBlurhash,
                                    height: 42,
                                    aspect: 1
                                )
                                .frame(width: 42, height: 42)
                                .clipShape(.circle)
                                userInfoView(oAuthData: oAuthData)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .foregroundStyle(Color.primary)
                        }
                    }
                }
                .onDelete { indexSet in
                    OAuthDataManager.shared.oAuthDatas.remove(atOffsets: indexSet) // TODO: -
                }
            }
            Button {
                model.selectedSheet = nil
                path.append(NavigationType.login)
            } label: {
                Text("Add Account")
            }
            .padding(.bottom, 16)
        }
    }
    
    @ViewBuilder
    private func userInfoView(oAuthData: OauthData) -> some View {
        if let user = oAuthData.user {
            let name: String = {
                guard let displayName = user.displayName,
                      !displayName.isEmpty
                else {
                    return user.username
                }
                return displayName
            }()
            VStack(alignment: .leading) {
                HtmlText(rawHtml: name, emojis: user.emojis.toRemoteEmojis, emojiSize: DesignFont.FontSize.extralarge)
                    .font(DesignFont.Rounded.Bold.extralarge)
                
                Text("\(user.acct)@\(oAuthData.url.host() ?? "")")
                    .font(DesignFont.Default.Medium.small)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
            }
        }
    }
    
    @ViewBuilder
    private func followAndFollowerView(user: FediverseAccountEntity) -> some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                Text(SuffixNumber.format(user.followingCount))
                    .font(DesignFont.Rounded.Bold.normal)
                Text("following")
                    .font(DesignFont.Rounded.Medium.normal)
            }
            Divider()
                .padding(.vertical, 2)
                .padding(.horizontal, 6)
            HStack(spacing: 2) {
                Text(SuffixNumber.format(user.followersCount))
                    .font(DesignFont.Rounded.Bold.normal)
                Text("followers")
                    .font(DesignFont.Rounded.Medium.normal)
            }
        }
        .frame(height: 36)
        .padding(.horizontal, 24)
        .background {
            NeumorphicBackgroundView(isInnerShadowEnabled: true, shape: Capsule())
        }
    }
    
    @ViewBuilder
    private var buttonsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                Button {
                    KingfisherManager.shared.cache.clearCache()
                } label: {
                    HStack {
                        Label {
                            Text("cache-clear")
                                .font(DesignFont.Rounded.Medium.large)
                        } icon: {
                            Image(systemName: "person.fill")
                        }
                        .frame(height: 32)
                        Spacer()
                    }
                    .padding(.trailing, 56)
                }
                .softButtonStyle(RoundedRectangle(cornerRadius: 8, style: .continuous), padding: 4)
            }
            .padding(16)
        }
        .padding(.horizontal, -16)
    }
}

#Preview {
    SideBarDisplayView(path: .constant(NavigationPath()), model: .init(), oAuthData: FediverseMockData.oAuthData)
}
