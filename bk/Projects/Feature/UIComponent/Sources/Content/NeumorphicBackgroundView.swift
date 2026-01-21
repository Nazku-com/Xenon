//
//  NeumorphicBackgroundView.swift
//  UIComponent
//
//  Created by 김수환 on 1/28/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import Neumorphic

public struct NeumorphicBackgroundView<ShapeStyle: Shape>: View {
    
    let isInnerShadowEnabled: Bool
    
    public var body: some View {
        if isInnerShadowEnabled {
            shape
                .fill(Color.Neumorphic.main)
                .softInnerShadow(shape)
        } else {
            shape
                .fill(Color.Neumorphic.main)
                .softOuterShadow()
        }
    }
    
    let shape: ShapeStyle
    public init(isInnerShadowEnabled: Bool = false, shape: ShapeStyle = RoundedRectangle(cornerRadius: 16, style: .continuous)) {
        self.isInnerShadowEnabled = isInnerShadowEnabled
        self.shape = shape
    }
}
