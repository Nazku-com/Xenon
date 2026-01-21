//
//  URLHandler.swift
//  xenon
//
//  Created by 김수환 on 2/5/25.
//

import SwiftUI
import FediverseFeature

struct URLHandler {
    
    static let shared = URLHandler()
    
    func checkDestination(_ url: URL) async -> URLType {
        let type = await checkURLType(for: url)
        return type
    }
    
    private func checkURLType(for url: URL) async -> URLType {
        if url.pathComponents.contains(where: { $0 == "tags" }),
           let tag = url.pathComponents.last
        {
            return .hashtag(tag: tag)
        }
        if url.lastPathComponent.first == "@",
           let host = url.host() {
            let handle = "\(url.lastPathComponent)@\(host)"
            if let account = await OAuthDataManager.shared.currentOAuthData?.userInfo(handle: handle) {
                return .handle(account: account)
            }
        }
        return .url(url: url)
    }
    
    
    private init() {}
}

extension URLHandler {
    
    enum URLType: Hashable {
        
        case handle(account: FediverseAccountEntity)
        case hashtag(tag: String)
        case url(url: URL)
    }
}

