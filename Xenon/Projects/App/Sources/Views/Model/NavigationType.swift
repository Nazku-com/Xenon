//
//  NavigationType.swift
//  xenon
//
//  Created by 김수환 on 2/7/25.
//

import SwiftUI
import FediverseFeature

enum NavigationType: Hashable {
    
    case userAccountInfo(FediverseAccountEntity)
    case login
    case url(URLHandler.URLType)
}
