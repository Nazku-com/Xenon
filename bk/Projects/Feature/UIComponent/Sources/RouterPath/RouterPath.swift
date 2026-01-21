//
//  RouterPath.swift
//  UIComponent
//
//  Created by 김수환 on 3/8/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import Observation

@MainActor
@Observable public class RouterPath {
    
    public var path: NavigationPath
    
    public init(path: NavigationPath = .init()) {
        self.path = path
    }
}
