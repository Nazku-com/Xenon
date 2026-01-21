//
//  HolloAPI.swift
//  FediverseFeature
//
//  Created by 김수환 on 2/13/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
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
    
    public var method: NetworkingFeature.HttpMethod {
        switch self {
        case .timeline:
            return .get
        }
    }
    
    public var headers: [String: String] {
        switch self {
        case .timeline(_, let token, _, _, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token.accessToken)"
            ]
        }
    }
    
    public var body: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .timeline(_, _, _, let minID, let maxID):
            var parameters: [URLQueryItem] = [
                .init(name: "limit", value: "20")
            ]
            if let minID {
                parameters.append(.init(name: "min_id", value: minID))
            }
            if let maxID {
                parameters.append(.init(name: "max_id", value: maxID))
            }
            return parameters
        default:
            return []
        }
    }
    
    public var uploadData: NetworkingFeature.MultipartFormData? {
        switch self {
        default:
            return nil
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
