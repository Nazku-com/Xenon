//
//  NetworkingEntityType.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation

public protocol NetworkingEntityType: Codable { }

extension Array: NetworkingEntityType where Element: Codable {}
