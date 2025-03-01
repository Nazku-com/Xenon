//
//  OnFirstAppear.swift
//  UIComponent
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI

private struct OnFirstAppear: ViewModifier {
    let perform: () -> Void
    
    @State private var firstTime = true
    
    func body(content: Content) -> some View {
        content.onAppear {
            if firstTime {
                firstTime = false
                perform()
            }
        }
    }
}

public extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(perform: perform))
    }
}
