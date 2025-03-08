//
//  FediverseProfileView.swift
//  UIComponent
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import UIComponent
import EmojiText
import FediverseFeature

public struct FediverseProfileView: View {
    
    @ObservedObject var model: FediverseProfileViewModel
    @State private var bannerHeight: CGFloat = 0
    @Environment(RouterPath.self) private var routerPath
    
    public var body: some View {
        VStack {
            if let account = model.fediverseAccountData {
                contentView(account: account)
            } else {
                Text("Loading")
            }
        }.task { @MainActor in
            await model.fetch(fromBottom: false)
        }
    }
    
    @ViewBuilder func contentView(account: FediverseAccountEntity) -> some View {
        ScrollView {
            VStack {
                avatarView(account: account)
                FediverseProfileTabView()
            }
            .background {
                blurryBackground
            }
            .padding(.top, max(bannerHeight - Metric.avatarHeight / 2, 0))
        }
        .refreshable {
            Task { @MainActor in
                await model.fetch(fromBottom: false)
            }
        }
        .background {
            bannerView(account: account)
        }
        .animation(.easeInOut(duration: 0.4), value: bannerHeight)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Spacer()
                    ImageDetailPreviewView(
                        account.avatar,
                        blurHash: account.avatarBlurhash,
                        height: 32,
                        aspect: 1
                    )
                    .clipShape(.circle)
                    let name = account.displayName ?? account.username
                    HtmlText(rawHtml: name, emojis: account.emojis.toRemoteEmojis, emojiSize: DesignFont.FontSize.normal)
                        .font(DesignFont.Rounded.Bold.normal)
                        .padding(.trailing, 32)
                    Spacer()
                }
                .frame(height: 32)
            }
        }
    }
    
    @ViewBuilder
    private func avatarView(account: FediverseAccountEntity) -> some View {
        HStack {
            VStack(alignment: .leading) {
                ImageDetailPreviewView(
                    account.avatar,
                    blurHash: account.avatarBlurhash,
                    height: Metric.avatarHeight,
                    aspect: 1
                )
                .frame(width: Metric.avatarHeight, height: Metric.avatarHeight)
                .background(.ultraThinMaterial)
                .clipShape(.circle)
                .overlay(
                    Circle()
                        .stroke(.primary, lineWidth: 2)
                )
                HStack {
                    let name = account.displayName ?? account.username
                    HtmlText(rawHtml: name, emojis: account.emojis.toRemoteEmojis, emojiSize: DesignFont.FontSize.extralarge)
                        .font(DesignFont.Rounded.Bold.extralarge)
                    
                    Spacer()
                    
                    followButtonView
                }
                Text(account.acct)
                    .font(DesignFont.Default.Medium.small)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Button {
                        routerPath.path.append(Notification(name: .NeedNavigationNotification, object: FollowingListView.Initializer(id: account.id, contentType: .following))) // TODO: -
                    } label: {
                        Text(SuffixNumber.format(account.followingCount))
                            .font(DesignFont.Rounded.Bold.normal)
                        Text("following")
                            .font(DesignFont.Rounded.Medium.small)
                            .padding(.trailing, 12)
                    }
                    
                    Button {
                        routerPath.path.append(Notification(name: .NeedNavigationNotification, object: FollowingListView.Initializer(id: account.id, contentType: .follower))) // TODO: -
                    } label: {
                        Text(SuffixNumber.format(account.followersCount))
                            .font(DesignFont.Rounded.Bold.normal)
                        Text("followers")
                            .font(DesignFont.Rounded.Medium.small)
                    }
                }
                .foregroundStyle(.primary)
                .padding(.bottom, 24)
                
                let remoteEmojis = account.emojis.toRemoteEmojis
                HtmlText(rawHtml: account.note, emojis: remoteEmojis, emojiSize: DesignFont.FontSize.normal)
                    .font(DesignFont.Rounded.Bold.normal)
                    .padding(.bottom, 8)
                
                ForEach(account.fields) { field in
                    VStack(alignment: .leading) {
                        HtmlText(rawHtml: field.name, emojis: remoteEmojis, emojiSize: DesignFont.FontSize.extraSmall)
                            .font(DesignFont.Default.Medium.extraSmall)
                            .foregroundStyle(.secondary)
                        HtmlText(rawHtml: field.value, emojis: remoteEmojis, emojiSize: DesignFont.FontSize.extraSmall)
                            .font(DesignFont.Default.Medium.small)
                            .foregroundStyle(.primary)
                    }
                    .padding(.bottom, 4)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, Metric.avatarHeight)
    }
    
    @ViewBuilder
    private var followButtonView: some View {
        if model.fediverseAccountData?.id == model.oAuthData.user?.id {
            EmptyView()
        } else if model.followState == .following {
            Menu {
                Button {
                    Task {
                        await model.unfollowUser()
                    }
                } label: {
                    Text("Unfollow")
                }
            } label: {
                model.followState.view
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background {
                        Capsule()
                    }
            }
        } else {
            Button {
                Task {
                    if model.followState == .notFollowing {
                        await model.followUser()
                    }
                }
            } label: {
                model.followState.view
                    .foregroundStyle(.white)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 16)
                    .background {
                        Capsule()
                    }
            }
        }
    }
    
    @ViewBuilder
    private var blurryBackground: some View {
        VStack(spacing: 0) {
            let color = Color(uiColor: UIColor.systemBackground)
            LinearGradient(colors: [.clear, color], startPoint: .top, endPoint: .bottom)
                .frame(height: 64)
            color
        }
        .padding(.top, Metric.avatarHeight)
    }
    
    @ViewBuilder
    private func bannerView(account: FediverseAccountEntity) -> some View {
        VStack {
            KFImageView(
                account.header,
                blurHash: account.headerBlurhash,
                height: Metric.bannerHeight,
                aspect: 1
            )
            .blur(radius: 10)
            .scaleEffect(1.4)
            .overlay {
                KFImageView(
                    account.header,
                    blurHash: account.headerBlurhash,
                    height: Metric.bannerHeight,
                    aspect: 1
                )
                .variableBlur(radius: 30) { geometryProxy, context in
                    context.addFilter(
                        .blur(radius: 8)
                    )
                    context.clip(
                        to: Path(CGRect(
                            origin: .init(x: 0, y: 12),
                            size: .init(
                                width: geometryProxy.size.width,
                                height: geometryProxy.size.height - 24
                            )
                        )), options: .inverse
                    )
                    context.fill(
                        Path(geometryProxy.frame(in: .local)),
                        with: .color(.white)
                    )
                }
            }
            .onGeometryChange(for: CGFloat.self, of: { proxy in
                proxy.size.height
            }, action: { newValue in
                bannerHeight = newValue
            })
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

// MARK: - Constant

private extension FediverseProfileView {
    
    enum Metric {
        
        static let avatarHeight: CGFloat = 70
        static let bannerHeight: CGFloat = 180
    }
}
