//
//  MastodonAPI.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

public struct AccountStatusData {
    let onlyMedia: Bool
    let excludeReplies: Bool
    let excludeReblogs: Bool
    let pinned: Bool
    let minID: String?
    let maxID: String?
}

public enum MastodonAPI {
    
    case registerApp(from: URL, appInfo: AppInfoType)
    case createToken(from: URL, code: String, clientId: String, clientSecret: String, appInfo: AppInfoType)
    case checkUserInfo(from: URL, token: OauthTokenEntity)
    case timeline(from: URL, token: OauthTokenEntity, of: TimelineType, minID: String?, maxID: String?)
    case accountStatus(from: URL, token: OauthTokenEntity, id: String, data: AccountStatusData)
    case setFavorite(from: URL, token: OauthTokenEntity, id: String)
    case unFavorite(from: URL, token: OauthTokenEntity, id: String)
    case lookup(from: URL, token: OauthTokenEntity, handle: String)
    case context(from: URL, token: OauthTokenEntity, id: String)
    case notifications(from: URL, token: OauthTokenEntity, minID: String?, maxID: String?)
    case conversations(from: URL, token: OauthTokenEntity)
    case relationships(from: URL, token: OauthTokenEntity, id: String)
    case follow(from: URL, token: OauthTokenEntity, id: String)
    case unfollow(from: URL, token: OauthTokenEntity, id: String)
    case followers(from: URL, token: OauthTokenEntity, id: String) // TODO: - Pagination
    case following(from: URL, token: OauthTokenEntity, id: String) // TODO: - Pagination
    case boost(from: URL, token: OauthTokenEntity, id: String)
    case unboost(from: URL, token: OauthTokenEntity, id: String)
    case post(from: URL, token: OauthTokenEntity, content: String, visibility: FediverseResponseEntity.Visibility)
}

@available(macOS 13.3, *)
extension MastodonAPI: NetworkingAPIType {
    
    public var baseURL: URL {
        switch self {
        case .registerApp(let url, _), .createToken(let url, _, _, _, _), .checkUserInfo(let url, _),
                .timeline(let url, _, _, _, _), .accountStatus(let url, _, _, _), .setFavorite(let url, _, _),
                .unFavorite(let url, _, _), .lookup(let url, _, _), .context(let url, _, _),
                .notifications(let url, _, _, _), .conversations(let url, _),
                .relationships(let url, _, _), .follow(let url, _, _), .unfollow(let url, _, _),
                .followers(let url, _, _), .following(let url, _, _), .boost(let url, _, _), .unboost(let url, _, _), .post(let url, _, _, _):
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
        case .accountStatus(_, _, let id, _):
            return "/api/v1/accounts/\(id)/statuses/"
        case .setFavorite(_, _, let id):
            return "/api/v1/statuses/\(id)/favourite"
        case .unFavorite(_, _, let id):
            return "/api/v1/statuses/\(id)/unfavourite"
        case .lookup:
            return "/api/v1/accounts/lookup"
        case .context(_, _, let id):
            return "/api/v1/statuses/\(id)/context"
        case .notifications:
            return "/api/v1/notifications"
        case .conversations:
            return "/api/v1/conversations"
        case .relationships:
            return "/api/v1/accounts/relationships"
        case .follow(_, _, let id):
            return "/api/v1/accounts/\(id)/follow"
        case .unfollow(_, _, let id):
            return "/api/v1/accounts/\(id)/unfollow"
        case .followers(_, _, let id):
            return "/api/v1/accounts/\(id)/followers"
        case .following(_, _, let id):
            return "/api/v1/accounts/\(id)/following"
        case .boost(_, _, let id):
            return "/api/v1/statuses/\(id)/reblog"
        case .unboost(_, _, let id):
            return "/api/v1/statuses/\(id)/unreblog"
        case .post:
            return "/api/v1/statuses"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .checkUserInfo, .timeline, .accountStatus, .lookup, .context,
                .notifications, .conversations, .relationships, .followers, .following:
            return .get
        case .registerApp, .createToken, .setFavorite, .unFavorite, .follow, .unfollow,
                .boost, .unboost, .post:
            return .post
        }
    }
    
    public var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .registerApp, .createToken:
            return HTTPHeaders([
                "Content-Type": "application/json"
            ])
        case .checkUserInfo(_, let token), .timeline(_, let token, _, _, _),
                .accountStatus(_, let token, _, _), .setFavorite(_, let token, _),
                .unFavorite(_, let token, _), .lookup(_, let token, _),
                .context(_, let token, _), .notifications(_, let token, _, _),
                .conversations(_, let token), .relationships(_, let token, _),
                .follow(_, let token, _), .unfollow(_, let token, _),.followers(_, let token, _),
                .following(_, let token, _), .boost(_, let token, _), .unboost(_, let token, _), .post(_, let token, _, _):
            return HTTPHeaders([
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token.accessToken)"
            ])
        }
    }
    
    public var bodyData: Alamofire.Parameters? {
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
        case .post(_, _, let content, let visibility):
            return [
                "language": "ko", // TODO: -
                "media_attributes": [], // TODO: -
                "media_ids": [],
                "status": content,
                "visibility": visibility.rawValue
            ]
            
        default:
            return nil
        }
    }
    
    public var parameters: Alamofire.Parameters? {
        switch self {
        case .timeline(_, _, let type, let minID, let maxID):
            var parameters: [String: Any] = [
                "limit": 20
            ]
            if type == .home
                || type == .local
                || type == .global
                || type == .hybrid
            {
                parameters["local"] = (type == .home || type == .local || type == .hybrid)
                parameters["remote"] = (type == .hybrid || type == .global)
            }
            if let minID {
                parameters["min_id"] = minID
            }
            if let maxID {
                parameters["max_id"] = maxID
            }
            return parameters
            
        case .lookup(_, _, let handle):
            return [
                "acct": handle
            ]
        case .notifications(_, _, let minID, let maxID):
            var parameters: [String: Any] = [
                "limit": 30
            ]
            if let minID {
                parameters["min_id"] = minID
            }
            if let maxID {
                parameters["max_id"] = maxID
            }
            return parameters
            
        case .accountStatus(_, _, _, let data):
            var parameters: [String: Any] = [
                "only_media": data.onlyMedia,
                "exclude_replies": data.excludeReplies,
                "exclude_reblogs": data.excludeReblogs,
                "pinned": data.pinned
            ]
            if let minID = data.minID {
                parameters["min_id"] = minID
            }
            if let maxID = data.maxID {
                parameters["max_id"] = maxID
            }
            return parameters
            
        case .relationships(_, _, let id):
            return [
                "id": id
            ]
            
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
