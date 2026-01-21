//
//  NotificationsDBManager.swift
//  xenon
//
//  Created by 김수환 on 12/24/25.
//

import Foundation
import FediverseFeature
import SQLite3

final actor FediNotificationsDBManager {
    
    static let shared = FediNotificationsDBManager()
    
    let db: DatabaseService?
    
    init() {
        self.db = try? .init(databaseName: "FediverseInformation.sqlite3")
        Task {
            await createTable()
        }
    }
    
    func createTable() async {
        let query = """
                  CREATE TABLE IF NOT EXISTS Notification(
                  id TEXT PRIMARY KEY,
                  type TEXT NOT NULL,
                  account_id TEXT,
                  status_id TEXT NOT NULL,
                  created_at REAL NOT NULL
                  );
                  """
        try? await db?.createTable(query: query)
    }
    
    func save(_ entities: [FediverseNotificationEntity]) async throws {
        for entity in entities {
            if let response = entity.account {
                try await FediAccountDBManager.shared.save(response)
            }
        }
    }
    
    func test(from entity: FediverseNotificationEntity) async throws {
//        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
//        try await db?.insertData(query: "insert into Notification values(?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET type = ?, account_id = ?,status_id = ?, created_at = ?;") { statement in
//            sqlite3_bind_text(statement, 1, entity.id, -1, SQLITE_TRANSIENT)
//            sqlite3_bind_text(statement, 2, entity.type.rawValue, -1, SQLITE_TRANSIENT)
//            sqlite3_bind_text(statement, 3, entity.account?.id, -1, SQLITE_TRANSIENT)
//            sqlite3_bind_text(statement, 4, entity.status?.id, -1, SQLITE_TRANSIENT)
//            sqlite3_bind_double(statement, 5, entity.createdAt.timeIntervalSince1970)
//            sqlite3_bind_text(statement, 6, entity.type.rawValue, -1, SQLITE_TRANSIENT)
//            sqlite3_bind_text(statement, 7, entity.account?.id, -1, SQLITE_TRANSIENT)
//            sqlite3_bind_text(statement, 8, entity.status?.id, -1, SQLITE_TRANSIENT)
//            sqlite3_bind_double(statement, 9, entity.createdAt.timeIntervalSince1970)
//        }
 
//        let result = try await db?.readData(query: "select * from Notification", queryMapper: { _ in }) { statement in
//            return FediverseNotificationEntity(
//                id: String(cString: sqlite3_column_text(statement, 0)),
//                type: .init(fromRawValue: String(cString: sqlite3_column_text(statement, 1))),
//                account: nil,
//                status: nil,
//                createdAt: .init(timeIntervalSince1970: sqlite3_column_double(statement, 4))
//            )
//        }
//        print(result)
        
        
    }
}


final actor FediAccountDBManager {
    
    static let shared = FediAccountDBManager()
    
    private let db: DatabaseService?
    
    init() {
        self.db = try? .init(databaseName: "FediverseInformation.sqlite3")
        Task {
            await createTable()
        }
    }
    
    func save(_ entity: FediverseAccountEntity) async throws {
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let query = """
        insert into Account values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET 
            username = ?, 
            acct = ?, 
            display_name = ?, 
            note = ?, 
            url = ?, 
            avatar = ?, 
            avatar_blurhash = ?, 
            header = ?, 
            header_blurhash = ?, 
            locked = ?, 
            created_at = ?, 
            follower_count = ?, 
            following_count = ?, 
            statuse_count = ?, 
            field_ids = ?, 
            emojies = ?
        """
        
        try await db?.insertData(query: query) { statement in
            sqlite3_bind_text(statement, 1, entity.id, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 2, entity.username, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 3, entity.acct, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 4, entity.displayName, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 5, entity.note, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 6, entity.url?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 7, entity.avatar?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 8, entity.avatarBlurhash, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 9, entity.header?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 10, entity.headerBlurhash, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(statement, 11, Int32(entity.locked ? 1 : 0))
            sqlite3_bind_double(statement, 12, entity.createdAt.timeIntervalSince1970)
            sqlite3_bind_int(statement, 13, Int32(entity.followersCount))
            sqlite3_bind_int(statement, 14, Int32(entity.followingCount))
            sqlite3_bind_int(statement, 15, Int32(entity.statusesCount ?? 0))
            sqlite3_bind_text(statement, 16, entity.fields.map({ $0.id.uuidString }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 17, entity.emojis.map({ "\($0.key):\($0.value)" }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 18, entity.username, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 19, entity.acct, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 20, entity.displayName, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 21, entity.note, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 22, entity.url?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 23, entity.avatar?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 24, entity.avatarBlurhash, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 25, entity.header?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 26, entity.headerBlurhash, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(statement, 27, Int32(entity.locked ? 1 : 0))
            sqlite3_bind_double(statement, 28, entity.createdAt.timeIntervalSince1970)
            sqlite3_bind_int(statement, 29, Int32(entity.followersCount))
            sqlite3_bind_int(statement, 30, Int32(entity.followingCount))
            sqlite3_bind_int(statement, 31, Int32(entity.statusesCount ?? 0))
            sqlite3_bind_text(statement, 32, entity.fields.map({ $0.id.uuidString }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 33, entity.emojis.map({ "\($0.key):\($0.value)" }).joined(separator: ","), -1, SQLITE_TRANSIENT)
        }
        
        let fieldQuery = """
        insert into AccountField values(?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET
            name = ?,
            value = ?,
            verified_at = ?;
        """
        
        for field in entity.fields {
            try await db?.insertData(query: fieldQuery) { statement in
                sqlite3_bind_text(statement, 1, field.id.uuidString, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 2, field.name, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 3, field.value, -1, SQLITE_TRANSIENT)
                sqlite3_bind_double(statement, 4, field.verifiedAt?.timeIntervalSince1970 ?? .zero)
                sqlite3_bind_text(statement, 5, field.name, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 6, field.value, -1, SQLITE_TRANSIENT)
                sqlite3_bind_double(statement, 7, field.verifiedAt?.timeIntervalSince1970 ?? .zero)
            }
        }
    }
    
    func createTable() async {
        let query = """
                  CREATE TABLE IF NOT EXISTS Account(
                  id TEXT PRIMARY KEY,
                  username TEXT,
                  acct TEXT NOT NULL,
                  display_name TEXT
                  url TEXT,
                  avatar TEXT,
                  avatar_blurhash Text,
                  locked INTEGER NOT NULL,
                  emojies TEXT
                  );
                  """
        try? await db?.createTable(query: query)
    }
}


final actor FediResponseDBManager {
    
    static let shared = FediResponseDBManager()
    
    private let db: DatabaseService?
    
    func save(_ entity: FediverseResponseEntity) async throws {
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        let query = """
        insert into Response values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET
            uri = ?, 
            url = ?, 
            account_id = ?, 
            in_replyto_account_id = ?, 
            content = ?, 
            attached_urls = ?, 
            created_at = ?, 
            emojies = ?, 
            reblog_count = ?, 
            favourite_count = ?, 
            reblogged = ?, 
            favourited = ?, 
            sensitive = ?, 
            spoiler_text = ?, 
            visibility = ?, 
            media_attachment_ids = ?, 
            mentions = ?, 
            tags = ?, 
            application = ?, 
            language = ?, 
            reblog_id = ?, 
            pinned = ?;
        """
        try await db?.insertData(query: query) { statement in
            sqlite3_bind_text(statement, 1, entity.id, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 2, entity.uri, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 3, entity.url?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 4, entity.account.id, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 5, entity.inReplyToAccountID, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 6, entity.content, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 7, entity.attachedURLs.map({ $0.absoluteString }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_double(statement, 8, entity.createdAt.timeIntervalSince1970)
            sqlite3_bind_text(statement, 9, entity.emojis.map({ "\($0.key):\($0.value)" }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(statement, 10, Int32(entity.reblogsCount))
            sqlite3_bind_int(statement, 11, Int32(entity.favouritesCount))
            sqlite3_bind_int(statement, 12, Int32(entity.reblogged ? 1 : 0))
            sqlite3_bind_int(statement, 13, Int32(entity.favourited ? 1 : 0))
            sqlite3_bind_int(statement, 14, Int32(entity.sensitive ? 1 : 0))
            sqlite3_bind_text(statement, 15, entity.spoilerText, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 16, entity.visibility.rawValue, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 17, entity.mediaAttachments.map({ $0.id }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 18, entity.mentions.map({ "\($0.id)-\($0.username)-\($0.acct)-\($0.url)" }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 19, entity.tags.map({ "\($0.name)-\($0.url)"}).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 20, entity.application.map({ "\($0.name)-\($0.website ?? "")"}), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 21, entity.language, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 22, entity.reblog?.id, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(statement, 23, Int32(entity.pinned ? 1 : 0))
            sqlite3_bind_text(statement, 24, entity.uri, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 25, entity.url?.absoluteString, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 26, entity.account.id, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 27, entity.inReplyToAccountID, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 28, entity.content, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 29, entity.attachedURLs.map({ $0.absoluteString }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_double(statement, 30, entity.createdAt.timeIntervalSince1970)
            sqlite3_bind_text(statement, 30, entity.emojis.map({ "\($0.key):\($0.value)" }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(statement, 32, Int32(entity.reblogsCount))
            sqlite3_bind_int(statement, 33, Int32(entity.favouritesCount))
            sqlite3_bind_int(statement, 34, Int32(entity.reblogged ? 1 : 0))
            sqlite3_bind_int(statement, 35, Int32(entity.favourited ? 1 : 0))
            sqlite3_bind_int(statement, 36, Int32(entity.sensitive ? 1 : 0))
            sqlite3_bind_text(statement, 37, entity.spoilerText, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 38, entity.visibility.rawValue, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 39, entity.mediaAttachments.map({ $0.id }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 40, entity.mentions.map({ "\($0.id)-\($0.username)-\($0.acct)-\($0.url)" }).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 41, entity.tags.map({ "\($0.name)-\($0.url)"}).joined(separator: ","), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 42, entity.application.map({ "\($0.name)-\($0.website ?? "")"}), -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 43, entity.language, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(statement, 44, entity.reblog?.id, -1, SQLITE_TRANSIENT)
            sqlite3_bind_int(statement, 45, Int32(entity.pinned ? 1 : 0))
        }
        let mediaAttachmentQuery = """
        insert into MediaAttachment values(?, ?, ?, ?, ?, ?, ?, ?) ON CONFLICT(id) DO UPDATE SET
            type = ?,
            url = ?,
            remote_url = ?,
            preview_url = ?,
            description = ?,
            aspect = ?,
            blurhash = ?;
        """
        for attachment in entity.mediaAttachments {
            try await db?.insertData(query: mediaAttachmentQuery) { statement in
                sqlite3_bind_text(statement, 1, attachment.id, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 2, attachment.url?.absoluteString, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 3, attachment.remoteURL?.absoluteString, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 4, attachment.previewURL?.absoluteString, -1, SQLITE_TRANSIENT)
                sqlite3_bind_text(statement, 5, attachment.description, -1, SQLITE_TRANSIENT)
                sqlite3_bind_double(statement, 6, attachment.aspect ?? .zero)
                sqlite3_bind_text(statement, 7, attachment.blurhash, -1, SQLITE_TRANSIENT)
            }
        }
    }
    
    init() {
        self.db = try? .init(databaseName: "FediverseInformation.sqlite3")
        Task {
            await createTable()
        }
    }
    
    func createTable() async {
        let query = """
                  CREATE TABLE IF NOT EXISTS Response(
                  id TEXT PRIMARY KEY,
                  uri TEXT NOT NULL,
                  url TEXT,
                  account_id TEXT NOT NULL,
                  in_replyto_account_id TEXT,
                  content TEXT NOT NULL,
                  attached_urls TEXT NOT NULL,
                  created_at REAL NOT NULL,
                  emojies TEXT,
                  reblog_count INTEGER NOT NULL,
                  favourite_count INTEGER NOT NULL,
                  reblogged INTEGER NOT NULL,
                  favourited INTEGER NOT NULL,
                  sensitive INTEGER NOT NULL,
                  spoiler_text TEXT NOT NULL,
                  visibility TEXT NOT NULL,
                  media_attachment_ids TEXT NOT NULL,
                  mentions TEXT NOT NULL,
                  tags TEXT NOT NULL,
                  application TEXT,
                  language TEXT,
                  reblog_id TEXT,
                  pinned INTEGER NOT NULL
                  );
                  """
        try? await db?.createTable(query: query)
        
        let mediaAttachmentquery = """
                  CREATE TABLE IF NOT EXISTS MediaAttachment(
                  id TEXT PRIMARY KEY,
                  type TEXT NOT NULL,
                  url TEXT,
                  remote_url TEXT,
                  preview_url TEXT,
                  description TEXT,
                  aspect REAL,
                  blurhash TEXT
                  );
                  """
        try? await db?.createTable(query: mediaAttachmentquery)
    }
}
