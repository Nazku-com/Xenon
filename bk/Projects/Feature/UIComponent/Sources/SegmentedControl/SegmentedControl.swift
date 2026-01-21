//
//  SegmentedControl.swift
//  UIComponent
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import SwiftUIIntrospect

public struct SegmentedControl: View {
    
    @Namespace var namespace
    let contentList: [String]
    @Binding var selectedContent: String
    
    public var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack {
                    ForEach(contentList, id: \.self) { content in
                        let isSelected = selectedContent == content
                        VStack {
                            if isSelected {
                                Text(content)
                                    .lineLimit(1)
                                    .padding(.horizontal, 20)
                                    .font(DesignFont.Rounded.Bold.normal)
                                Capsule()
                                    .fill(Color.primary)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "selectedTab", in: namespace)
                            } else {
                                Text(content)
                                    .lineLimit(1)
                                    .padding(.horizontal, 20)
                                    .font(DesignFont.Rounded.Medium.normal)
                                Capsule()
                                    .fill(Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .id(content)
                        .onTapGesture {
                            withAnimation(.smooth(duration: 0.1)) {
                                selectedContent = content
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .introspect(.scrollView, on: .iOS(.v16, .v17, .v18)) { scrollView in
                scrollView.alwaysBounceVertical = false
                scrollView.alwaysBounceHorizontal = false
                scrollView.bounces = false
            }
            .scrollIndicators(.hidden)
            .onChange(of: selectedContent) { _, newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
    
    public init(contentList: [String], selectedContent: Binding<String>) {
        self.contentList = contentList
        _selectedContent = selectedContent
    }
}
