//
//  View+onFirstAppearTask.swift
//  Sugar
//
//  Created by 김수환 on 12/27/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI

extension View {
    
    public func onFirstAppearTask(action: @escaping () async -> Void) -> some View {
        modifier(OnFirstAppearModifier(action: action))
    }
}

struct OnFirstAppearModifier: ViewModifier {
    
    @State private var isFirstAppear: Bool = false
    
    var action: () async -> Void
    
    func body(content: Content) -> some View {
        content.task {
            guard !isFirstAppear else { return }
            isFirstAppear = true
            await action()
        }
    }
}
