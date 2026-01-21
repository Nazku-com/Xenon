//
//  AppInfoType.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation

public protocol AppInfoType {
    
    var clientName: String { get }
    var scheme: String { get }
    var weblink: String { get }
}
