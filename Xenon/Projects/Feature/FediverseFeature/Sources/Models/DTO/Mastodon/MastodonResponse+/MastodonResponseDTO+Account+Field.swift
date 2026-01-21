//
//  Field.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/26/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import Foundation
import NetworkingFeature
import Sugar

public extension MastodonResponseDTO.Account {
    
    final class Field: NetworkingDTOType {
        
        let name: String?
        let value: String?
        let verifiedAt: String?
        
        private enum CodingKeys: String, CodingKey {
            case name
            case value
            case verifiedAt = "verified_at"
        }
        
        public func toEntity() async -> FediverseAccountEntity.Field {
            var date: Date? {
                guard let verifiedAt else {
                    return nil
                }
                return DateFormatter.fediverseFormatter.date(from: verifiedAt)
            }
            async let name = name?.parseHTMLToMarkdown()
            async let value = value?.parseHTMLToMarkdown()
            return .init(
                name: await name ?? "",
                value: await value ?? "",
                verifiedAt: date
            )
        }
    }
}
