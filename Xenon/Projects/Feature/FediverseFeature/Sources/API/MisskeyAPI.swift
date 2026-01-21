//
//  MisskeyAPI.swift
//  FediverseFeature
//
//  Created by 김수환 on 10/25/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//


import Foundation
import NetworkingFeature

public enum MisskeyAPI {
    
    case createSession(from: URL, session: String, appInfo: AppInfoType)
    case createToken(from: URL, session: String)
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
                .createReaction(let url, _, _, _),
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
        case .createToken, .createReaction,
                .deleteReaction, .singleNote, .userShow,
                .replies, .revokeToken, .boost:
            return .post
        case .createSession:
            return .get
        }
    }
    
    public var headers: [String : String] {
        switch self {
        case .createReaction(_, let token, _, _),
                .deleteReaction(_, let token, _), .singleNote(_, let token, _),
                .userShow(_, let token, _, _), .replies(_, let token, _),
                .boost(_, _, let token):
            return [
                "Authorization": "Bearer \(token.accessToken)",
                "Content-Type": "application/json"
            ]
        default:
            return [:]
        }
    }
    
    public var body: [String : Any] {
        switch self {
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
                .init(name: "callback", value: appInfo.scheme),
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
