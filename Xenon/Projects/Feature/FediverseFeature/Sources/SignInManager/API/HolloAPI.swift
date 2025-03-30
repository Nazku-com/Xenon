//
//  HolloAPI.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/13/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

public enum HolloAPI {
    
    case timeline(from: URL, token: OauthTokenEntity, of: TimelineType, minID: String?, maxID: String?)
}

@available(macOS 13.3, *)
extension HolloAPI: NetworkingAPIType {
    
    public var baseURL: URL {
        switch self {
        case .timeline(let url, _, _, _, _):
            return url
        }
    }
    
    public var path: String? {
        switch self {
        case .timeline(_, _, let type, _, _):
            return type.path
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .timeline:
            return .get
        }
    }
    
    public var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .timeline(_, let token, _, _, _):
            return HTTPHeaders([
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token.accessToken)"
            ])
        }
    }
    
    public var bodyData: Alamofire.Parameters? {
        switch self {
        default:
            return nil
        }
    }
    
    public var parameters: Alamofire.Parameters? {
        switch self {
        case .timeline(_, _, _, let minID, let maxID):
            var parameters: [String: Any] = [
                "limit": 20
            ]
            if let minID {
                parameters["min_id"] = minID
            }
            if let maxID {
                parameters["max_id"] = maxID
            }
            return parameters
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
    
    public var encoding: any Alamofire.ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
}

private extension TimelineType {
    
    var path: String {
        switch self {
        case .home:
            return "/api/v1/timelines/home"
        case .local:
            return "/api/v1/timelines/public"
        case .hybrid:
            return "/api/v1/timelines/public"
        case .global:
            return "/api/v1/timelines/public"
        case .hashtag(let tag):
            return "/api/v1/timelines/tag/\(tag)"
        }
    }
}
