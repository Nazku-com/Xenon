//
//  hideSharedBackgroundVisibility.swift
//  Sugar
//
//  Created by 김수환 on 12/17/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI

public extension ToolbarContent {
    
    @ToolbarContentBuilder
    var hideSharedBackgroundVisibility: some ToolbarContent {
        if #available(iOS 26.0, *) {
            self.sharedBackgroundVisibility(.hidden)
        } else {
            self
        }
    }
}

