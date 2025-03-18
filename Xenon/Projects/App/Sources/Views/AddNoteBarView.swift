//
//  AddNoteBarView.swift
//  xenon
//
//  Created by 김수환 on 2/22/25.
//

import SwiftUI
import FediverseFeature
import UIComponent

struct AddNoteBarView: View {
    
    @Binding var isPresented: Bool
    
    @State var text: String = ""
    @State var selectedContent: Content? = nil
    @FocusState private var isFocused: Bool
    @State var customEmojis = [String: [CustomEmojiEntity]]()
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField(
                "Type here...",
                text: $text,
                axis: .vertical
            )
            .focused($isFocused)
            .lineSpacing(10.0)
            .foregroundStyle(.primary)
            .padding(4)
            .onAppear {
                isFocused = true
            }
            
            Spacer()
            HStack {
                Menu {
                    ForEach(Content.allCases, id: \.self) { content in
                        Button {
                            isFocused = false
                            selectedContent = content
                        } label: {
                            Text(content.rawValue)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .softButtonStyle(Circle(), padding: 8)
                .frame(width: 32, height: 32)
                
                Spacer()
                
                Button {
                    Task {
                        isPresented = false
                        AppDelegate.instance.showLoading(true)
                        let _ = await OAuthDataManager.shared.currentOAuthData?.post(content: text, visibility: .public) // TODO: -
                        AppDelegate.instance.showLoading(false)
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .softButtonStyle(Circle(), padding: 8)
                .frame(width: 32, height: 32)
            }
            extraContent
                .frame(height: selectedContent == nil ? 0 : 200)
        }
        .padding(16)
        .padding(.vertical, 8)
        .background(Color.Neumorphic.main)
        .presentationDetents([
            .medium,
        ])
        .animation(.easeInOut, value: selectedContent)
        .onChange(of: isFocused) { _, newValue in
            if newValue {
                selectedContent = nil
            }
        }
        .task {
            guard customEmojis.isEmpty else { return }
            if let result = await OAuthDataManager.shared.currentOAuthData?.customEmojis() {
                switch result {
                case .success(let emojis):
                    customEmojis = emojis
                case .failure:
                    return // TODO: -
                }
            }
        }
    }
    
    @ViewBuilder
    private var extraContent: some View {
        switch selectedContent {
        case .emoji:
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(customEmojis.sorted(by: { $0.key.lowercased() < $1.key.lowercased() }), id: \.key) { key, values in
                        Text(key)
                            .font(DesignFont.Default.Bold.normal)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40), spacing: 8)], spacing: 8) {
                            ForEach(values, id: \.self) { value in
                                KFImageView(value.url, height: 40, aspect: 1)
                                    .onTapGesture {
                                        text.append(" :\(value.shortcode):")
                                    }
                            }
                        }
                    }
                }
            }
        case nil:
            EmptyView()
        }
    }
    
    enum Content: String, CaseIterable {
        case emoji
    }
}
