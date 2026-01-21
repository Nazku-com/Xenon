//
//  MastodonAPI.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//


import Foundation
import NetworkingFeature

public enum MastodonAPI {
    
    case registerApp(from: URL, appInfo: AppInfoType)
    case createToken(from: URL, code: String, clientId: String, clientSecret: String, appInfo: AppInfoType)
    case checkUserInfo(from: URL, token: OauthTokenEntity)
    case timeline(from: URL, token: OauthTokenEntity, of: TimelineType, minID: String?, maxID: String?)
    case notifications(from: URL, token: OauthTokenEntity)
    case get(from: URL, token: OauthTokenEntity)
    case context(from: URL, token: OauthTokenEntity, id: String)
}

@available(macOS 13.3, *)
extension MastodonAPI: NetworkingAPIType {
    
    public var baseURL: URL {
        switch self {
        case .registerApp(let url, _), .createToken(let url, _, _, _, _), .checkUserInfo(let url, _), .timeline(let url, _, _, _, _), .notifications(let url, _),
                .get(let url, _), .context(let url, _, _):
            return url
        }
    }
    
    public var path: String? {
        switch self {
        case .registerApp:
            return "/api/v1/apps"
        case .createToken:
            return "/oauth/token"
        case .checkUserInfo:
            return "/api/v1/accounts/verify_credentials"
        case .timeline(_, _, let type, _, _):
            return type.path
        case .notifications(_, _):
            return "/api/v1/notifications"
        case .context(_, _, let id):
            return "/api/v1/statuses/\(id)/context"
        default:
            return nil
        }
    }
    
    public var method: NetworkingFeature.HttpMethod {
        switch self {
        case .checkUserInfo, .timeline, .notifications, .get, .context:
            return .get
        case .registerApp, .createToken:
            return .post
        }
    }
    
    public var headers: [String : String]  {
        switch self {
        case .registerApp, .createToken:
            return [
                "Content-Type": "application/json"
            ]
        case .checkUserInfo(_, let token), .timeline(_, let token, _, _, _), .notifications(_, let token), .get(_, let token), .context(_, let token, _):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token.accessToken)"
            ]
        }
    }
    
    public var body: [String : Any] {
        switch self {
        case .registerApp(_, let appInfo):
            return [
                "client_name": appInfo.clientName,
                "redirect_uris": appInfo.scheme,
                "scopes": "read write follow push",
                "website": appInfo.weblink
            ]
        case .createToken(_, let code, let clientId, let clientSecret, let appInfo):
            return [
                "grant_type": "authorization_code",
                "code": code,
                "client_id": clientId,
                "client_secret": clientSecret,
                "redirect_uri": appInfo.scheme,
                "scope": "read write follow push"
            ]
        default:
            return [:]
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .timeline(_, _, let type, let minID, let maxID):
            var parameters: [URLQueryItem] = [
                .init(name: "limit", value: "20")
            ]
            if type == .federated {
                parameters.append(.init(name: "local", value: "false"))
            }
            if let minID {
                parameters.append(.init(name: "min_id", value: minID))
            }
            if let maxID {
                parameters.append(.init(name: "max_id", value: maxID))
            }
            return parameters
        case .notifications(_, _):
            let parameters: [URLQueryItem] = [
                .init(name: "limit", value: "30")
            ]
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
        case .federated:
            return "/api/v1/timelines/public"
        case .tranding:
            return "/api/v1/trends/statuses"
        case .hashtag(let tag):
            return "/api/v1/timelines/tag/\(tag)"
        }
    }
}
