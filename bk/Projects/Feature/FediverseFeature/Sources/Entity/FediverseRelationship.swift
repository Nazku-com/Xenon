//
//  FediverseRelationship.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/23/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import SwiftUI
import NetworkingFeature

public struct FediverseRelationship: NetworkingEntityType {
    
    public let id: String
    public let following: Bool
    public let followed_by: Bool
    public let muting: Bool
    public let muting_notifications: Bool
    public let requested: Bool
    public let requested_by: Bool
    public let domain_blocking: Bool
    public let endorsed: Bool
}
