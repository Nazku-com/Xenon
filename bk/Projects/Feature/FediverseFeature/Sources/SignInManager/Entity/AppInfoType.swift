//
//  AppInfoType.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation

public protocol AppInfoType {
    
    var clientName: String { get }
    var scheme: String { get }
    var weblink: String { get }
}
