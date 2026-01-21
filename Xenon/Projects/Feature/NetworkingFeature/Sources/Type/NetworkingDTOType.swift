//
//  NetworkingDTOType.swift
//  NetworkingFeature
//
//  Created by 김수환 on 12/2/24.
//  Copyright © 2024 test.tuist. All rights reserved.
//

import Foundation

public protocol NetworkingDTOType: Codable, Sendable {
    
    associatedtype EntityType: NetworkingEntityType
    @NetworkingEntityConvertActor
    func toEntity() async throws -> EntityType
}

extension Array: NetworkingDTOType where Element: NetworkingDTOType {
    
    public typealias EntityType = [Element.EntityType]

    public func toEntity() async throws -> EntityType {
        try await withThrowingTaskGroup(of: (Int, Element.EntityType?).self) { group in
            for i in self.indices {
                group.addTask {
                    return(i, try? await self[i].toEntity())
                }
            }

            var entities: [Int: Element.EntityType] = [:]
            for try await (index, entity) in group {
                entities[index] = entity
            }

            return entities.sorted(by: {$0.key < $1.key }).compactMap({ $0.value })
        }
    }
}
