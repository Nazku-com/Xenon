//
//  UIApplication+FirstKeyWindow.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import UIKit

extension UIApplication {
    
    var firstKeyWindow: UIWindow? {
        connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first
    }
}
