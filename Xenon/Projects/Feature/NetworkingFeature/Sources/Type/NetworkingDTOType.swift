//
//  NetworkingDTOType.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation

public protocol NetworkingDTOType: Codable {
    
    associatedtype EntityType: NetworkingEntityType
    func toEntity() -> EntityType
}

extension Array: NetworkingDTOType where Element: NetworkingDTOType {
    
    public typealias EntityType = [Element.EntityType]

    public func toEntity() -> EntityType {
        compactMap { $0.toEntity() }
    }
}
