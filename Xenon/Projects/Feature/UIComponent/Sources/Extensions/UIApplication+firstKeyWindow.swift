//
//  UIApplication+firstKeyWindow.swift
//  UIComponent
//
//  Created by 김수환 on 3/10/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var firstKeyWindow: UIWindow? {
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }
        return (scene as? UIWindowScene)?.keyWindow
    }
}
