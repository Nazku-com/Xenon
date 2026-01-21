//
//  UIApplication+firstKeyWindow.swift
//  Sugar
//
//  Created by 김수환 on 12/28/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import UIKit

public extension UIApplication {
    
    var firstKeyWindow: UIWindow? {
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window
    }
}
