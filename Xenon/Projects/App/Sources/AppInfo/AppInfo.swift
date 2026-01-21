//
//  AppInfo.swift
//  xenon
//
//  Created by 김수환 on 12/14/25.
//

import FediverseFeature

public struct AppInfo: AppInfoType {
    
    static let shared = AppInfo()
    public let clientName = "xenon"
    public let scheme = "xenon://"
    public let weblink = "https://xenon.social/@xenon"
    public let defaultServer = "xenon.social"
}
