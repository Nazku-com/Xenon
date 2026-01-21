//
//  WellKnownNodeInfoEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

struct WellKnownNodeInfoEntity: NetworkingEntityType {
    
    let rel: URL?
    let href: URL?
}
