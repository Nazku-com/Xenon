//
//  SideBarView.swift
//  UIComponent
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import SwiftUIIntrospect
import Combine

public final class SideBarViewModel: ObservableObject {
    
    public let sideBarOpenPublisher = PassthroughSubject<Bool,Never>()
    public let sideBarOpenablePublisher = PassthroughSubject<Bool,Never>()
    
    public static let shared = SideBarViewModel()
    private init() {}
}

public struct SideBarView<SideBar: View, Content: View>: View {
    
    let sideBar: SideBar
    let content: Content
    
    public init(model: SideBarViewModel, @ViewBuilder sideBar: () -> SideBar, @ViewBuilder content: () -> Content) {
        self.model = model
        self.sideBar = sideBar()
        self.content = content()
    }
    
    @State private var canOpenSideBar = true
    @State private var dimmValue: CGFloat = 0
    @ObservedObject private var model: SideBarViewModel
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        sideBar
                            .id(0)
                            .frame(height: proxy.size.height)
                        content
                            .overlay {
                                Color.black.opacity(dimmValue).ignoresSafeArea()
                                    .onTapGesture {
                                        withAnimation {
                                            scrollProxy.scrollTo(1)
                                        }
                                    }
                            }
                            .background(GeometryReader {
                                Color.clear.preference(
                                    key: SideBarScrollOffsetKey.self,
                                    value: max($0.frame(in: .named("area")).origin.x, 0)
                                )
                            })
                            .id(1)
                            .frame(width: proxy.size.width, height: proxy.size.height)
                            .onAppear {
                                scrollProxy.scrollTo(1)
                            }
                    }
                    .onReceive(model.sideBarOpenPublisher) { openSideBar in
                        guard canOpenSideBar else { return }
                        withAnimation {
                            scrollProxy.scrollTo(openSideBar ? 0 : 1)
                        }
                    }
                    .onReceive(model.sideBarOpenablePublisher) { canOpenSideBar in
                        self.canOpenSideBar = canOpenSideBar
                    }
                }
                .scrollDisabled(!canOpenSideBar)
                .introspect(.scrollView, on: .iOS(.v13, .v14, .v15, .v16, .v17, .v18)) { scrollView in
                    scrollView.alwaysBounceVertical = false
                    scrollView.alwaysBounceHorizontal = false
                    scrollView.bounces = false
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .background(Color.Neumorphic.main)
                .coordinateSpace(name: "area")
                .onPreferenceChange(SideBarScrollOffsetKey.self) { value in
                    let maxFrameToDimm: CGFloat = min(proxy.size.width / 2, 200)
                    dimmValue = (min(value, maxFrameToDimm) / (maxFrameToDimm * 2))
                }
                .onRotate { _ in
                    scrollProxy.scrollTo(1)
                }
            }
        }
    }
}

struct SideBarScrollOffsetKey: PreferenceKey {
    
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
