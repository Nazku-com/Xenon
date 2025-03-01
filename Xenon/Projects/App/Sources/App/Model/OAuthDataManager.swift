//
//  OAuthDataManager.swift
//  xenon
//
//  Created by 김수환 on 2/8/25.
//

import SwiftUI
import FediverseFeature

final class OAuthDataManager: ObservableObject {
    
    @Published var currentOAuthData: OauthData? = loadCurrentOAuthData() {
        didSet {
            Self.save(oAuthData: currentOAuthData)
        }
    }
    @Published var oAuthDatas = load() {
        didSet {
            Self.save(oAuthDatas: oAuthDatas)
            if let currentOAuthData,
               !oAuthDatas.contains(currentOAuthData) {
                self.currentOAuthData = oAuthDatas.first
            }
        }
    }
    
    static let shared = OAuthDataManager()
    
    // MARK: - Save
    
    fileprivate static func save(oAuthData: OauthData?) {
        guard
            let fileURL = Path.currentOAuthfileURL,
            let data = try? JSONEncoder().encode(oAuthData)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    fileprivate static func save(oAuthDatas: [OauthData]) {
        guard
            let fileURL = Path.oAuthListfileURL,
            let data = try? JSONEncoder().encode(oAuthDatas)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    // MARK: - Load
    
    fileprivate static func loadCurrentOAuthData() -> OauthData? {
        guard let fileURL = Path.currentOAuthfileURL,
              let data = try? Data(contentsOf: fileURL),
              let oAuthData = try? JSONDecoder().decode(OauthData.self, from: data) else {
            return nil
        }
        return oAuthData
    }
    
    fileprivate static func load() -> [OauthData] {
        guard let fileURL = Path.oAuthListfileURL,
              let data = try? Data(contentsOf: fileURL),
              let oAuthDatas = try? JSONDecoder().decode([OauthData].self, from: data) else {
            return []
        }
        return oAuthDatas
    }
    
    private init () {}
}

private extension OAuthDataManager {
    
    enum Path {
        static var oAuthDataURL: URL? {
            guard let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                return nil
            }
            let documentsDirectoryURL = applicationSupportDirectoryURL.appendingPathComponent("Documents")
            let preventKeyModelURL = documentsDirectoryURL.appendingPathComponent("OAuthData")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: preventKeyModelURL.absoluteString) {
                try? fileManager.createDirectory(
                    at: preventKeyModelURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
            return preventKeyModelURL
        }
        
        static var currentOAuthfileURL: URL? {
            return oAuthDataURL?.appendingPathComponent("oAuthData.json")
        }
        static var oAuthListfileURL: URL? {
            return oAuthDataURL?.appendingPathComponent("oAuthData-list.json")
        }
    }
}
