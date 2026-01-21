//
//  SideBarView.swift
//  UIComponent
//
//  Created by 김수환 on 12/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import Combine
import Sugar

public struct SideBarView<SideBarView: View, ContentView: View>: View {
    
    let sideBarOpenPublisher: PassthroughSubject<Void, Never>
    let sideBarView: () -> SideBarView
    let contentView: () -> ContentView
    
    @State private var offsetX: CGFloat = .zero
    @State private var sideBarWidth: CGFloat = .zero
    
    public var body: some View {
        VStack {
            contentView()
                .overlay {
                    Color.black.opacity(offsetX/sideBarWidth * 0.1).ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.15)) {
                                offsetX = .zero
                            }
                        }
                }
                .overlay(alignment: .leading) {
                    sideBarView()
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.15)) {
                                offsetX = .zero
                            }
                        }
                        .onReadSize { size in
                            sideBarWidth = size.width + 80
                        }
                        .offset(x: min(max(offsetX - sideBarWidth, -sideBarWidth), 0))
                }
        }.gesture(
            DragGesture()
                .onChanged { value in
                    guard offsetX < sideBarWidth else { return }
                    offsetX = value.translation.width
                }
                .onEnded { _ in
                    withAnimation {
                        if offsetX > sideBarWidth / 3 {
                            offsetX = sideBarWidth
                        } else {
                            offsetX = .zero
                        }
                    }
                }
        )
        .onReceive(sideBarOpenPublisher) { _ in
            withAnimation {
                offsetX = sideBarWidth
            }
        }
    }
    
    public init(
        sideBarOpenPublisher: PassthroughSubject<Void, Never> = .init(),
        sideBarView: @escaping () -> SideBarView,
        contentView: @escaping () -> ContentView
    ) {
        self.sideBarOpenPublisher = sideBarOpenPublisher
        self.sideBarView = sideBarView
        self.contentView = contentView
    }
}
