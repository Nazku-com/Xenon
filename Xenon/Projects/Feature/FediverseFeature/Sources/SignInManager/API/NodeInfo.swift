//
//  NodeInfo.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
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
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .nodeInfo, .get:
            return .get
        }
    }
    
    public var headers: Alamofire.HTTPHeaders? {
        switch self {
        default:
            return HTTPHeaders([
                "Content-Type": "application/json"
            ])
        }
    }
    
    public var bodyData: Alamofire.Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    public var uploadData: NetworkingFeature.MultipartFormData? {
        switch self {
        default:
            return nil
        }
    }
    
    public var parameters: Alamofire.Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    public var encoding: any Alamofire.ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
}
