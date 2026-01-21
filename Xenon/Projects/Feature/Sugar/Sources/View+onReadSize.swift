//
//  View+onReadSize.swift
//  Sugar
//
//  Created by 김수환 on 12/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    public func onReadSize(_ perform: @escaping (CGSize) -> Void) -> some View {
        self.customBackground {
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: perform)
    }
    
    @ViewBuilder
    func customBackground<V: View>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View {
        self.background(alignment: alignment, content: content)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}
