//
//  URLHandler.swift
//  xenon
//
//  Created by 김수환 on 2/5/25.
//

import SwiftUI

struct URLHandler {
    
    static let shared = URLHandler()
    
    func checkDestination(_ url: URL) -> URLType {
        let type = checkURLType(for: url)
        return type
    }
    
    private func checkURLType(for url: URL) -> URLType {
        if url.pathComponents.contains(where: { $0 == "tags" }),
           let tag = url.pathComponents.last
        {
            return .hashtag(tag: tag)
        }
        if url.lastPathComponent.first == "@",
           let host = url.host() {
            let handle = "\(url.lastPathComponent)@\(host)"
            return .handle(handle: handle)
        }
        return .url(url: url)
    }
    
    
    private init() {}
}

extension URLHandler {
    
    enum URLType: Hashable {
        
        case handle(handle: String)
        case hashtag(tag: String)
        case url(url: URL)
    }
}

