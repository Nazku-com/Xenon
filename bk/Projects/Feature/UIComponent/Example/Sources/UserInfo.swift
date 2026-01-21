//
//  UserInfo.swift
//  example.UIComponent
//
//  Created by 김수환 on 1/27/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import FediverseFeature
import SwiftData

@Model
class UserInfo: Identifiable {
    var id = UUID()
    var oAuthData: OauthData
    
    init(oAuthData: OauthData) {
        self.oAuthData = oAuthData
    }
}
