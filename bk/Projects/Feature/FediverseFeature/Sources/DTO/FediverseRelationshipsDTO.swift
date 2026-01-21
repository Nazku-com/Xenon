//
//  FediverseRelationshipsDTO.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/23/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import NetworkingFeature

public struct FediverseRelationshipsDTO: NetworkingDTOType {
    let id: String
    let following: Bool
    let followed_by: Bool
    let muting: Bool
    let muting_notifications: Bool
    let requested: Bool
    let requested_by: Bool
    let domain_blocking: Bool
    let endorsed: Bool
    
    public func toEntity() -> FediverseRelationship {
        .init(
            id: id,
            following: following,
            followed_by: followed_by,
            muting: muting,
            muting_notifications: muting_notifications,
            requested: requested,
            requested_by: requested_by,
            domain_blocking: domain_blocking,
            endorsed: endorsed
        )
    }
}
