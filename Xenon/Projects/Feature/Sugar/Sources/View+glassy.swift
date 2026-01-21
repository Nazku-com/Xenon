//
//  View+glassy.swift
//  Sugar
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    public func glassy(in shape: any Shape = .capsule, tintColor: Color? = nil) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.tint(tintColor).interactive(), in: shape)
        } else {
            self.background(.ultraThinMaterial)
        }
    }
    @ViewBuilder
    public func clearGlassy(in shape: any Shape = .capsule) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.clear, in: shape)
        } else {
            self.background(.ultraThinMaterial)
        }
    }
}
