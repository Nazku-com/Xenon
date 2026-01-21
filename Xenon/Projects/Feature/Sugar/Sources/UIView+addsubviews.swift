//
//  UIView+addsubviews.swift
//  Sugar
//
//  Created by 김수환 on 12/29/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import UIKit

extension UIView {
    
    public func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
