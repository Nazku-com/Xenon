//
//  MisskeyAPI.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import NetworkingFeature

public enum MisskeyAPI {
    
    case createSession(from: URL, session: String, appInfo: AppInfoType)
    case createToken(from: URL, session: String)
    case timeline(
        from: URL,
        token: OauthTokenEntity,
        of: TimelineType,
        sinceID: String?,
        untilID: String?
    )
    case createReaction(from: URL, token: OauthTokenEntity, noteId: String, reaction: String)
    case deleteReaction(from: URL, token: OauthTokenEntity, noteId: String)
    case singleNote(from: URL, token: OauthTokenEntity, noteId: String)
    case userShow(from: URL, token: OauthTokenEntity, userName: String, host: String?)
    case replies(from: URL, token: OauthTokenEntity, noteId: String)
    case revokeToken(from: URL, token: OauthTokenEntity)
    case boost(from: URL, id: String, token: OauthTokenEntity)
}

extension MisskeyAPI: NetworkingAPIType {
    
    public var baseURL: URL {
        switch self {
        case .createToken(let url, _), .createSession(let url, _, _),
                .timeline(let url, _, _, _, _), .createReaction(let url, _, _, _),
                .deleteReaction(let url, _, _), .singleNote(let url, _, _),
                .userShow(let url, _, _, _), .replies(from: let url, _, _),
                .revokeToken(let url, _), .boost(let url, _, _):
            return url
        }
    }
    
    public var path: String? {
        switch self {
        case .createToken(_, let session):
            return "/api/miauth/\(session)/check"
        case .createSession(_, let session, _):
            return "/miauth/\(session)"
        case .timeline(_, _, let type, _, _):
            switch type {
            case .home:
                return "/api/notes/timeline"
            case .local:
                return "/api/notes/local-timeline"
            case .hybrid:
                return "/api/notes/hybrid-timeline"
            case .global:
                return "/api/notes/global-timeline"
            case .hashtag(tag: let tag):
                return "" // TODO: -
            }
        case .createReaction:
            return "/api/notes/reactions/create"
        case .deleteReaction:
            return "api/notes/reactions/delete"
        case .singleNote:
            return "/api/notes/show"
        case .userShow:
            return "/api/users/show"
        case .replies:
            return "/api/notes/replies"
        case .revokeToken:
            return "/api/i/revoke-token"
        case .boost:
            return "/api/notes/create"
        }
    }
    
    public var method: NetworkingFeature.HttpMethod {
        switch self {
        case .createToken, .timeline, .createReaction,
                .deleteReaction, .singleNote, .userShow,
                .replies, .revokeToken, .boost:
            return .post
        case .createSession:
            return .get
        }
    }
    
    public var headers: [String : String] {
        switch self {
        case .timeline(_, let token, _, _, _), .createReaction(_, let token, _, _),
                .deleteReaction(_, let token, _), .singleNote(_, let token, _),
                .userShow(_, let token, _, _), .replies(_, let token, _),
                .boost(_, _, let token):
            return [
                "Authorization": "Bearer \(token.accessToken)",
                "Content-Type": "application/json"
            ]
        default:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
    
    public var body: [String : Any] {
        switch self {
        case .timeline(_, _, _, let sinceID, let untilID):
            var body: [String: Any] = [
                "limit": 10,
                "allowPartial": false,
                "includeMyRenotes": true,
                "includeRenotedMyNotes": true,
                "includeLocalRenotes": true,
                "withFiles": false,
                "withRenotes": true
            ]
            if let sinceID {
                body["sinceId"] = sinceID
            }
            if let untilID {
                body["untilId"] = untilID
            }
            return body
        case .createReaction(_, _, let noteId, let reaction):
            return [
                "noteId": noteId,
                "reaction": reaction
            ]
        case .deleteReaction(_, _, let noteId), .singleNote(_, _, let noteId):
            return [
                "noteId": noteId
            ]
        case .userShow(_, _, let userName, let host):
            if let host {
                return [
                    "username": userName,
                    "host": host
                ]
            } else {
                return [
                    "username": userName
                ]
            }
        case .replies(_, _, let noteId):
            return [
                "noteId": noteId
            ]
        case .revokeToken(_, let token):
            return [
                "tokenId": token.accessToken
            ]
        case .boost(_, let id, _):
            return [
                "renoteId": id
            ]
        default:
            return [:]
        }
    }
    
    public var queryItems: [URLQueryItem] {
        switch self {
        case .createSession(_, _, let appInfo):
            return [
                .init(name: "callback", value: "appInfo.scheme"),
                .init(name: "permission", value: [
                    "read:admin",
                    "write:admin",
                    
                    "read:account",
                    "read:blocks",
                    "read:channels",
                    "read:clip",
                    "read:drive",
                    "read:favorites",
                    "read:federation",
                    "read:flash",
                    "read:following",
                    "read:gallery",
                    "read:invite",
                    "read:messaging",
                    "read:mutes",
                    "read:notifications",
                    "read:page",
                    "read:pages",
                    "read:reactions",
                    "read:user",
                    
                    "write:account",
                    "write:blocks",
                    "write:channels",
                    "write:clip",
                    "write:drive",
                    "write:favorites",
                    "write:flash",
                    "write:following",
                    "write:gallery",
                    "write:invite",
                    "write:messaging",
                    "write:mutes",
                    "write:notes",
                    "write:notifications",
                    "write:page",
                    "write:pages",
                    "write:reactions",
                    "write:report-abuse",
                    "write:user",
                    "write:votes",
                ]
                    .joined(separator: ",")),
            ]
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
