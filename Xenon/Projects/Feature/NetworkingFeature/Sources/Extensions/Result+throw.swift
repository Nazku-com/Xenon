//
//  Result+throw.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/10/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation

public extension Result {
    
    func `throw`() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
