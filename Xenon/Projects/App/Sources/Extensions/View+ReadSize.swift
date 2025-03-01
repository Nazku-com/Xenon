//
//  View+ReadSize.swift
//  xenon
//
//  Created by 김수환 on 2/20/25.
//

import SwiftUI

extension View {
    
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

fileprivate struct SizePreferenceKey: PreferenceKey {
    
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
