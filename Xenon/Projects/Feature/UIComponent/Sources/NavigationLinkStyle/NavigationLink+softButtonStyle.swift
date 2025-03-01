//
//  NavigationLink+softButtonStyle.swift
//  UIComponent
//
//  Created by 김수환 on 1/29/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import Neumorphic

extension NavigationLink {
    
    public func softButtonStyle<S : Shape>(
        _ content: S, padding : CGFloat = 16,
        mainColor : Color = Color.Neumorphic.main,
        textColor : Color = Color.Neumorphic.secondary,
        darkShadowColor: Color = Color.Neumorphic.darkShadow,
        lightShadowColor: Color = Color.Neumorphic.lightShadow,
        pressedEffect : SoftButtonPressedEffect = .hard
    ) -> some View {
        self.buttonStyle(
            SoftDynamicButtonStyle(
                content,
                mainColor: mainColor,
                textColor: textColor,
                darkShadowColor: darkShadowColor,
                lightShadowColor: lightShadowColor,
                pressedEffect : pressedEffect,
                padding:padding)
        )
    }
}
