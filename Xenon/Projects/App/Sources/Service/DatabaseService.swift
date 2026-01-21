//
//  DatabaseService.swift
//  xenon
//
//  Created by 김수환 on 12/24/25.
//

import Foundation
import SQLite3

@globalActor final actor DatabaseActor: GlobalActor {
    public typealias ActorType = DatabaseActor
    public static let shared = DatabaseActor()
}

final class DatabaseService {
    
    var db : OpaquePointer?
    let databaseName: String
    
    
    // MARK: - Initialization
    
    init(databaseName: String) throws {
        self.databaseName = databaseName
        self.db = try createDB()
    }
    deinit {
        sqlite3_close(db)
    }
    
    private func createDB() throws -> OpaquePointer? {
        var db: OpaquePointer? = nil
        let dbPath: String = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false).appendingPathComponent(databaseName).path
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            return db
        }
        return nil
    }
    
    @DatabaseActor
    func createTable(query: String) throws {
        let query = query
        var statement: OpaquePointer? = nil
        defer { sqlite3_finalize(statement) }
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                return
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                throw DatabaseServiceError.TableCreateFailure(errorMessage)
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            throw DatabaseServiceError.TableCreateFailure(errorMessage)
        }
    }
    
    @DatabaseActor
    func insertData(query: String, mapper: (OpaquePointer?) -> Void) throws {
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            mapper(statement)
        } else {
            throw DatabaseServiceError.insertDataFailure("query prepare failed")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            throw DatabaseServiceError.insertDataFailure("sqlite step failure")
        }
    }
    
    @DatabaseActor
    func readData<T>(query: String, queryMapper: (OpaquePointer?) -> Void, mapper: (OpaquePointer?) throws -> T) throws -> [T] {
        var statement: OpaquePointer? = nil
        var results: [T] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            queryMapper(statement)
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            throw DatabaseServiceError.readDataFailure(errorMessage)
        }
        
        defer {
            sqlite3_finalize(statement)
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let value = try mapper(statement)
            results.append(value)
        }
        
        return results
    }
}

enum DatabaseServiceError: Error {
    
    case TableCreateFailure(String)
    case insertDataFailure(String)
    case readDataFailure(String)
}
