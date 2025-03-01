//
//  AppInfo.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import Foundation
import FediverseFeature

public struct AppInfo: AppInfoType {
    
    static let shared = AppInfo()
    public let clientName = "xenon"
    public let scheme = "xenon://"
    public let weblink = "https://github.com/tkgka/" // TODO: -
    public let defaultServer = "xenon.social" // TODO: -
}
