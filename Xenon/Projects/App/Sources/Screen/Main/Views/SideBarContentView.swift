//
//  SideBarContentView.swift
//  xenon
//
//  Created by Claude on 2/1/26.
//

import SwiftUI
import FediverseFeature
import UIComponent

struct SideBarContentView: View {

    @Environment(MainViewModel.self) private var mainViewModel
    @State private var isCreateFeedPresented: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            currentAccountHeader
            Divider()
                .padding(.vertical, 8)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    feedsSection
                    accountList
                }
            }
            Spacer()
            addAccountButton
        }
        .padding(16)
        .sheet(isPresented: $isCreateFeedPresented) {
            if let oAuthData = mainViewModel.currentOAuthData {
                CreateFeedView { title, timelineType, columns in
                    let feedModel = FeedViewModel(oAuthdata: oAuthData, columns: columns, timeline: timelineType)
                    mainViewModel.feedsViewModel.addFeed(.init(title: title, model: feedModel))
                }
            }
        }
    }

    // MARK: - Current Account Header

    @ViewBuilder
    private var currentAccountHeader: some View {
        if let current = mainViewModel.currentOAuthData {
            VStack(alignment: .leading, spacing: 8) {
                ImageView(url: current.user?.avatar)
                    .frame(width: 48, height: 48)
                    .clipShape(.circle)
                VStack(alignment: .leading, spacing: 2) {
                    Text(current.user?.displayName ?? current.user?.username ?? "")
                        .font(.styled(.subtitle))
                        .lineLimit(1)
                    Text("@\(current.user?.acct ?? "")")
                        .font(.styled(.caption))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Text(current.url.host() ?? "")
                        .font(.styled(.caption))
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }
            .padding(.bottom, 8)
        }
    }

    // MARK: - Feeds Section

    @ViewBuilder
    private var feedsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Feeds")
                .font(.styled(.caption))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
                .padding(.bottom, 4)

            ForEach(mainViewModel.feedsViewModel.feeds) { feed in
                HStack(spacing: 8) {
                    Image(systemName: "newspaper")
                        .foregroundStyle(.secondary)
                    Text(feed.title)
                        .font(.styled(.body))
                        .lineLimit(1)
                    Spacer()
                    if feed.title == mainViewModel.feedsViewModel.selectedTab {
                        Circle()
                            .fill(.blue)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(8)
                .contentShape(Rectangle())
                .onTapGesture {
                    mainViewModel.feedsViewModel.selectedTab = feed.title
                    mainViewModel.output.send(.dismissSideBar)
                }
                .contextMenu {
                    Button(role: .destructive) {
                        mainViewModel.feedsViewModel.removeFeed(title: feed.title)
                    } label: {
                        Label("Remove Feed", systemImage: "trash")
                    }
                }
            }

            Button {
                isCreateFeedPresented = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(.blue)
                    Text("Add Feed")
                        .font(.styled(.body))
                }
                .padding(8)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Account List

    @ViewBuilder
    private var accountList: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Accounts")
                .font(.styled(.caption))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
                .padding(.bottom, 4)

            ForEach(mainViewModel.oAuthDatas) { account in
                accountRow(account)
            }
        }
    }

    @ViewBuilder
    private func accountRow(_ account: OauthData) -> some View {
        let isCurrent = mainViewModel.currentOAuthData?.id == account.id
        Button {
            mainViewModel.switchAccount(to: account)
            mainViewModel.output.send(.dismissSideBar)
        } label: {
            HStack(spacing: 8) {
                ImageView(url: account.user?.avatar)
                    .frame(width: 32, height: 32)
                    .clipShape(.circle)
                VStack(alignment: .leading, spacing: 1) {
                    Text(account.user?.displayName ?? account.user?.username ?? "")
                        .font(.styled(.body))
                        .lineLimit(1)
                    Text(account.url.host() ?? "")
                        .font(.styled(.caption))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                if isCurrent {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.blue)
                }
            }
            .padding(8)
            .background {
                if isCurrent {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue.opacity(0.1))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            if mainViewModel.oAuthDatas.count > 1 {
                Button(role: .destructive) {
                    mainViewModel.removeAccount(account)
                } label: {
                    Label("Remove Account", systemImage: "trash")
                }
            }
        }
    }

    // MARK: - Add Account

    @ViewBuilder
    private var addAccountButton: some View {
        Button {
            mainViewModel.output.send(.addAccount)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "plus.circle.fill")
                    .font(.styled(.subtitle))
                Text("Add Account")
                    .font(.styled(.body))
            }
            .padding(8)
        }
        .buttonStyle(.plain)
    }
}
