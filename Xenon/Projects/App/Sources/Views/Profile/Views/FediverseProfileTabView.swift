//
//  FediverseProfileTabView.swift
//  xenon
//
//  Created by 김수환 on 2/20/25.
//

import SwiftUI
import UIComponent

struct FediverseProfileTabView: View {
    
    @State var selectedContent: String = SegmentContent.Post.rawValue
    @State var sizeArray = [String: CGFloat]()
    @State var height: CGFloat = 100

    var body: some View {
        LazyVStack(pinnedViews: .sectionHeaders) {
            Section {
                TabView(selection: $selectedContent) {
                    ForEach(SegmentContent.allCases, id: \.self) { content in
                        contentView(content)
                            .tag(content.rawValue)
                    }
                }
                .frame(height: height)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity)
                .onChange(of: selectedContent) { _, _ in
                    withAnimation {
                        height = sizeArray[selectedContent] ?? 100
                    }
                }.onChange(of: sizeArray) { _, _ in
                    height = sizeArray[selectedContent] ?? 100
                }
            } header: {
                SegmentedControl(
                    contentList: SegmentContent.allCases.compactMap({ $0.rawValue }),
                    selectedContent: $selectedContent
                )
                .padding(.top, 30)
                .background(Color(uiColor: .systemBackground))
            }
        }
    }
    
    @ViewBuilder
    private func contentView(_ content: SegmentContent) -> some View {
        switch content {
        case .Post:
            Text("Post")
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.yellow)
                .readSize { size in
                    sizeArray[content.rawValue] = size.height
                }
        case .Reply:
            Text("Reply")
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .background(.green)
                .readSize { size in
                    sizeArray[content.rawValue] = size.height
                }
        case .Media:
            Text("Media")
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(.blue)
                .readSize { size in
                    sizeArray[content.rawValue] = size.height
                }
        case .Likes:
            Text("Likes")
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .background(.red)
                .readSize { size in
                    sizeArray[content.rawValue] = size.height
                }
        }
    }
    
    
    enum SegmentContent: String, CaseIterable {
        
        case Post
        case Reply
        case Media
        case Likes
    }
}

#Preview {
    ScrollView {
        FediverseProfileTabView()
    }
}
