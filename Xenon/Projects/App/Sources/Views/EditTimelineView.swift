//
//  EditTimelineView.swift
//  xenon
//
//  Created by 김수환 on 3/1/25.
//

import SwiftUI
import FediverseFeature
import UIComponent

struct EditTimelineView: View {
    
    @ObservedObject private var oAuthDataManager = OAuthDataManager.shared
    @State var selectedUserID: String?
    @State var tabs = [SegmentedControlTab]()
    @State var isAddSheetShown = false
    
    @State private var hashTagName: String = ""
    @State private var contentType: ContentType = .global
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(oAuthDataManager.oAuthDatas) { oAuthData in
                        VStack {
                            userProfileView(oAuthData)
                                .onTapGesture {
                                    selectedUserID = oAuthData.user?.id
                                }
                        }
                    }
                }
            }
            if let selectedUserID {
                HStack {
                    Button {
                        hashTagName = ""
                        isAddSheetShown.toggle()
                    } label: {
                        Text("Add")
                    }
                    Spacer()
                    EditButton()
                }
                .padding(.top, 16)
                List {
                    ForEach(tabs, id:\.title) { tab in
                        Text(tab.title)
                    }
                    .onMove { indexSet, offset in
                        tabs.move(fromOffsets: indexSet, toOffset: offset)
                        SegmentedControlTabManager.shared.save(userID: selectedUserID, tabs: tabs)
                        NotificationCenter.default.post(name: .NeedRefreshSegmentControl, object: nil)
                    }
                    .onDelete { indexSet in
                        tabs.remove(atOffsets: indexSet)
                        SegmentedControlTabManager.shared.save(userID: selectedUserID, tabs: tabs)
                        NotificationCenter.default.post(name: .NeedRefreshSegmentControl, object: nil)
                    }
                }
                .listStyle(.plain)
                .sheet(isPresented: $isAddSheetShown) {
                    VStack(spacing: 8) {
                        
                        if contentType == .hashtag {
                            TextField("HashTag", text: $hashTagName)
                                .padding(.top, 32)
                        }
                        
                        Picker("", selection: $contentType) {
                            ForEach(ContentType.allCases, id: \.self) { choice in
                                Text(choice.rawValue)
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Spacer()
                        
                        Button {
                            guard contentType != .hashtag || (contentType == .hashtag && !hashTagName.isEmpty)
                            else {
                                return
                            }
                            
                            let type = SegmentedControlTab.ContentType.fediverse(
                                contentType.asTimelineType(hashtagName: hashTagName)
                            )
                            let title = contentType == .hashtag ? "#\(hashTagName)" : contentType.rawValue
                            
                            tabs.append(.init(title: title, contentType: type))
                            SegmentedControlTabManager.shared.save(userID: selectedUserID, tabs: tabs)
                            NotificationCenter.default.post(name: .NeedRefreshSegmentControl, object: nil)
                            isAddSheetShown = false
                        } label: {
                            Text("add")
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.blue)
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .presentationDetents([
                        .medium
                    ])
                    .animation(.easeInOut, value: selectedUserID)
                    .animation(.easeInOut, value: contentType)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .onFirstAppear {
            selectedUserID = oAuthDataManager.oAuthDatas.first?.user?.id
        }
        .onChange(of: selectedUserID) { _, newValue in
            tabs = SegmentedControlTabManager.shared.tabs(for: selectedUserID)
        }
    }
    
    @ViewBuilder
    private func userProfileView(_ oAuthData: OauthData) -> some View {
        if let user = oAuthData.user {
            VStack {
                KFImageView(
                    user.avatar,
                    blurHash: user.avatarBlurhash,
                    height: 42,
                    aspect: 1
                )
                .frame(width: 42, height: 42)
                .clipShape(.circle)
                .overlay {
                    Circle()
                        .stroke(selectedUserID == user.id ? .blue : .clear, lineWidth: 2)
                }
                Text("\(user.acct)@\n\(oAuthData.url.host() ?? "")")
                    .multilineTextAlignment(.center)
                    .font(DesignFont.Default.Medium.small)
                    .foregroundStyle(.secondary)
            }
        } else {
            EmptyView()
        }
    }
    
    enum ContentType: String, CaseIterable {
        
        case home
        case local
        case hybrid
        case global
        case hashtag
        
        func asTimelineType(hashtagName: String) -> TimelineType {
            switch self {
            case .home:
                return .home
            case .local:
                return .local
            case .hybrid:
                return .hybrid
            case .global:
                return .global
            case .hashtag:
                return .hashtag(tag: hashtagName)
            }
        }
    }
}

extension Notification.Name {
    
    static let NeedRefreshSegmentControl = Notification.Name("NeedRefreshSegmentControlNotification")
}
