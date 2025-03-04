//
//  FediverseResponseEntity.swift
//  FediverseFeature
//
//  Created by 김수환 on 1/26/25.
//  Copyright © 2025 com.Nazku. All rights reserved.
//

import Foundation
import Alamofire
import NetworkingFeature

public struct FediverseAccountEntity: NetworkingEntityType, Equatable, Hashable, Identifiable {
    
    public static func == (lhs: FediverseAccountEntity, rhs: FediverseAccountEntity) -> Bool {
        lhs.id == rhs.id
        && lhs.displayName == rhs.displayName
        && lhs.note == rhs.note
        && lhs.avatar == rhs.avatar
        && lhs.avatarBlurhash == rhs.avatarBlurhash
        && lhs.header == rhs.header
        && lhs.headerBlurhash == rhs.headerBlurhash
        && lhs.locked == rhs.locked
        && lhs.followersCount == rhs.followersCount
        && lhs.followingCount == rhs.followingCount
        && lhs.statusesCount == rhs.statusesCount
    }
    
    /// The ID of the account.
    public let id: String
    /// The username of the account.
    public let username: String
    /// Equals username for local users, includes @domain for remote ones.
    public var acct: String
    /// The account's display name.
    public let displayName: String?
    /// Biography of user.
    public let note: String
    /// URL of the user's profile page (can be remote).
    public var url: URL?
    /// URL to the avatar image.
    public let avatar: URL?
    /// Blurhash for avatar image
    public let avatarBlurhash: String?
    /// URL to the header image.
    public let header: URL?
    /// Blurhash for header image
    public let headerBlurhash: String?
    /// Boolean for when the account cannot be followed without waiting for approval first.
    public let locked: Bool
    /// The time the account was created.
    public let createdAt: Date
    /// The number of followers for the account.
    public let followersCount: Int
    /// The number of accounts the given account is following.
    public let followingCount: Int
    /// The number of statuses the account has made.
    public let statusesCount: Int?
    public let fields: [Field]
    public let emojis: Emojis
    
    public init(
        id: String,
        username: String,
        acct: String,
        displayName: String?,
        note: String,
        url: String,
        avatar: String,
        avatarBlurhash: String?,
        header: String,
        headerBlurhash: String?,
        locked: Bool,
        createdAt: Date,
        followersCount: Int,
        followingCount: Int,
        statusesCount: Int? = 0,
        fields: [Field],
        emojis: Emojis
    ) {
        self.id = id
        self.username = username
        self.acct = acct
        self.displayName = displayName
        self.note = note
        self.url = .init(string: url)
        self.avatar = .init(string: avatar)
        self.avatarBlurhash = avatarBlurhash
        self.header = .init(string: header)
        self.headerBlurhash = headerBlurhash
        self.locked = locked
        self.createdAt = createdAt
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.statusesCount = statusesCount
        self.fields = fields
        self.emojis = emojis
    }
    
    public struct Field: NetworkingEntityType, Hashable, Identifiable {
        
        public var id = UUID()
        public let name: String
        public let value: String
        public let verifiedAt: Date?
    }
}
