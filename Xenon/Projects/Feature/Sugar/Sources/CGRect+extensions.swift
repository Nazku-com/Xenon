//
//  CGRect+extensions.swift
//  Sugar
//
//  Created by 김수환 on 12/28/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation

public extension CGRect {
    
    func aspectFit(to frame: CGRect) -> CGRect {
        guard width != 0,
              height != 0
        else {
            return .init(origin: frame.origin, size: .init(width: 0, height: 0))
        }
        let ratio = width / height
        let frameRatio = frame.width / frame.height
        if frameRatio < ratio {
            return aspectFitWidth(to: frame)
        } else {
            return aspectFitHeight(to: frame)
        }
    }
    
    func aspectFitWidth(to frame: CGRect) -> CGRect {
        let ratio = width / height
        let height = frame.width * ratio
        let offsetY = (frame.height - height) / 2
        let origin = CGPoint(x: frame.origin.x, y: frame.origin.y + offsetY)
        let size = CGSize(width: frame.width, height: height)
        return CGRect(origin: origin, size: size)
    }
    
    func aspectFitHeight(to frame: CGRect) -> CGRect {
        let ratio = height / width
        let width = frame.height * ratio
        let offsetX = (frame.width - width) / 2
        let origin = CGPoint(x: frame.origin.x + offsetX, y: frame.origin.y)
        let size = CGSize(width: width, height: frame.height)
        return CGRect(origin: origin, size: size)
    }
}
