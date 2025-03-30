//
//  AddNoteBarView.swift
//  xenon
//
//  Created by 김수환 on 2/22/25.
//

import SwiftUI
import FediverseFeature
import NetworkingFeature
import UIComponent

final class AddNoteBarViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var customEmojis = [String: [CustomEmojiEntity]]()
    @Published var selectedImages = [UIImage]()
    @Published var selectedContent: AddNoteBarView.Content? = nil {
        didSet {
            isSheetPresented = selectedContent?.contentPresentType == .sheet
        }
    }
    @Published var isSheetPresented: Bool = false
}

struct AddNoteBarView: View {
    
    @Binding var isPresented: Bool
    @ObservedObject private var model = AddNoteBarViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(model.selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding([.top, .trailing], 8)
                            .padding(.trailing, 4)
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    model.selectedImages.removeAll(where: { $0 == image })
                                } label: {
                                    Circle()
                                        .fill(.black)
                                        .overlay {
                                            Image(systemName: "xmark")
                                                .renderingMode(.template)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundStyle(.white)
                                                .padding(4)
                                        }
                                        .padding(2)
                                        .frame(width: 24)
                                        .opacity(0.8)
                                }

                            }
                    }
                }
                .frame(height: model.selectedImages.count > 0 ? 80 : 0)
            }
            TextField(
                "Type here...",
                text: $model.text,
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
                            model.selectedContent = content
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
                        let _ = await OAuthDataManager.shared.currentOAuthData?.post(
                            content: model.text,
                            medias: model.selectedImages.compactMap({ image -> NetworkingFeature.MultipartFormData? in
                                guard let data = image.pngData() else { return nil }
                                return .init(fileName: "file", mimeType: "image/jpeg", data: data)
                            }),
                            visibility: .public
                        )
                        AppDelegate.instance.showLoading(false)
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .softButtonStyle(Circle(), padding: 8)
                .frame(width: 32, height: 32)
            }
            if model.selectedContent?.contentPresentType == .embed {
                extraContent
                    .frame(height: 200)
            }
        }
        .padding(16)
        .padding(.vertical, 8)
        .background(Color.Neumorphic.main)
        .presentationDetents([
            .medium,
        ])
        .animation(.easeInOut, value: model.selectedContent)
        .onChange(of: isFocused) { _, newValue in
            if newValue {
                model.selectedContent = nil
            }
        }
        .task {
            guard model.customEmojis.isEmpty else { return }
            if let result = await OAuthDataManager.shared.currentOAuthData?.customEmojis() {
                switch result {
                case .success(let emojis):
                    model.customEmojis = emojis
                case .failure:
                    return // TODO: -
                }
            }
        }
        .sheet(isPresented: $model.isSheetPresented) {
            extraContent
        }
        .animation(.easeInOut, value: model.selectedImages)
    }
    
    @ViewBuilder
    private var extraContent: some View {
        switch model.selectedContent {
        case .emoji:
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(model.customEmojis.sorted(by: { $0.key.lowercased() < $1.key.lowercased() }), id: \.key) { key, values in
                        Text(key)
                            .font(DesignFont.Default.Bold.normal)
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40), spacing: 8)], spacing: 8) {
                            ForEach(values, id: \.self) { value in
                                KFImageView(value.url, height: 40, aspect: 1)
                                    .onTapGesture {
                                        model.text.append(" :\(value.shortcode):")
                                    }
                            }
                        }
                    }
                }
            }
        case .photos:
            ImagePicker(pickerResult: $model.selectedImages, isPresented: $model.isSheetPresented)
        default:
            EmptyView()
        }
    }
    
    enum Content: String, CaseIterable {
        
        case emoji
        case photos
        
        enum ContentPresentType {
            case sheet
            case embed
        }
        
        var contentPresentType: ContentPresentType {
            switch self {
            case .emoji:
                    .embed
            case .photos:
                    .sheet
            }
        }
    }
}
