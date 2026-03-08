//
//  MainViewModel.swift
//  xenon
//
//  Created by 김수환 on 10/26/25.
//

import SwiftUI
import Combine
import FediverseFeature

@Observable
@MainActor
final class MainViewModel {
    
    let output: PassthroughSubject<Output, Never> = .init()
    var feedsViewModel: FeedsViewModel = .init(feeds: [])

    var isLoggedIn: Bool {
        !oAuthDatas.isEmpty
    }
    
    var oAuthDatas: [OauthData] = load() {
        didSet {
            Self.save(oAuthDatas: oAuthDatas)
        }
    }
    var currentOAuthData: OauthData? = loadCurrentOAuthData() {
        didSet {
            Self.save(oAuthData: currentOAuthData)
        }
    }
    
    func logIn(with oAuthData: OauthData) {
        if !oAuthDatas.contains(where: { $0.url == oAuthData.url && $0.token.accessToken == oAuthData.token.accessToken }) {
            oAuthDatas.append(oAuthData)
        }
        currentOAuthData = oAuthData
    }

    func switchAccount(to oAuthData: OauthData) {
        currentOAuthData = oAuthData
    }

    func removeAccount(_ oAuthData: OauthData) {
        oAuthDatas.removeAll { $0.id == oAuthData.id }
        if currentOAuthData?.id == oAuthData.id {
            currentOAuthData = oAuthDatas.first
        }
    }

    func navigateTo(_ viewController: UIViewController, withTapPoint point: CGPoint? = nil) {
        output.send(.navigateTo(viewController, point))
    }
}

// MARK: - Load / Save

private extension MainViewModel {
    
    static func save(oAuthData: OauthData?) {
        guard
            let fileURL = Path.currentOAuthfileURL,
            let data = try? JSONEncoder().encode(oAuthData)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    static func save(oAuthDatas: [OauthData]) {
        guard
            let fileURL = Path.oAuthListfileURL,
            let data = try? JSONEncoder().encode(oAuthDatas)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    // MARK: - Load
    
    static func loadCurrentOAuthData() -> OauthData? {
        guard let fileURL = Path.currentOAuthfileURL,
              let data = try? Data(contentsOf: fileURL),
              let oAuthData = try? JSONDecoder().decode(OauthData.self, from: data) else {
            return nil
        }
        return oAuthData
    }
    
    static func load() -> [OauthData] {
        guard let fileURL = Path.oAuthListfileURL,
              let data = try? Data(contentsOf: fileURL),
              let oAuthDatas = try? JSONDecoder().decode([OauthData].self, from: data) else {
            return []
        }
        return oAuthDatas
    }
}

// MARK: - Path

private extension MainViewModel {
    
    enum Path {
        static var oAuthDataURL: URL? {
            guard let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                return nil
            }
            let documentsDirectoryURL = applicationSupportDirectoryURL.appendingPathComponent("Documents")
            let url = documentsDirectoryURL.appendingPathComponent("OAuthData")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: url.absoluteString) {
                try? fileManager.createDirectory(
                    at: url,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            }
            return url
        }
        
        static var currentOAuthfileURL: URL? {
            return oAuthDataURL?.appendingPathComponent("oAuthData.json")
        }
        static var oAuthListfileURL: URL? {
            return oAuthDataURL?.appendingPathComponent("oAuthData-list.json")
        }
    }
}

// MARK: - Output

extension MainViewModel {
    
    enum Output {
        
        case navigateTo(UIViewController, CGPoint?)
        case openURL(URL)
        case toggleSideBarState
        case addAccount
        case dismissSideBar
    }
}
