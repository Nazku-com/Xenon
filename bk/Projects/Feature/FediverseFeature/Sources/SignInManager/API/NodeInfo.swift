//
//  NodeInfo.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public enum NodeInfoAPI {
    
    case nodeInfo(url: URL)
    case get(url: URL)
}

extension NodeInfoAPI: NetworkingAPIType {
    
    public var baseURL: URL {
        switch self {
        case .nodeInfo(let url), .get(let url):
            return url
        }
    }
    
    public var path: String? {
        switch self {
        case .nodeInfo:
            return "/.well-known/nodeinfo"
        case .get:
            return nil
        }
    }
    
    public var method: NetworkingFeature.HttpMethod {
        switch self {
        case .nodeInfo, .get:
            return .get
        }
    }
    
    public var headers: [String : String] {
        switch self {
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    public var body: [String : Any] {
        switch self {
        default:
            return [:]
        }
    }
    
    public var uploadData: NetworkingFeature.MultipartFormData? {
        switch self {
        default:
            return nil
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        default:
            return []
        }
    }
}
