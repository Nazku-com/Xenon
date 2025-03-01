//
//  SegmentedControlTabManager.swift
//  xenon
//
//  Created by 김수환 on 2/18/25.
//

import Foundation
import FediverseFeature

final class SegmentedControlTabManager {
    static var shared = SegmentedControlTabManager()
    private init() {}
    
    func tabs(for userID: String?) -> [SegmentedControlTab] {
        guard let userID else {
            return SegmentedControlTab.default
        }
        var data = load(userID: userID)
        if data.isEmpty {
            data = SegmentedControlTab.default
            save(userID: userID, tabs: data)
        }
        return data
    }
    
    private func save(userID: String, tabs: [SegmentedControlTab]) {
        guard
            let fileURL = Path.tabListURL(userID: userID),
            let data = try? JSONEncoder().encode(tabs)
        else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
    
    private func load(userID: String) -> [SegmentedControlTab] {
        guard let fileURL = Path.tabListURL(userID: userID),
              let data = try? Data(contentsOf: fileURL),
              let tabList = try? JSONDecoder().decode([SegmentedControlTab].self, from: data) else {
            return []
        }
        return tabList
    }
}

private extension SegmentedControlTabManager {
    
    enum Path {
        static var fileURL: URL? {
            guard let applicationSupportDirectoryURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
                return nil
            }
            let documentsDirectoryURL = applicationSupportDirectoryURL.appendingPathComponent("Documents")
            let preventKeyModelURL = documentsDirectoryURL.appendingPathComponent("SegmentedControlTab")
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
        
        static func tabListURL(userID: String) -> URL? {
            return fileURL?.appendingPathComponent("tabs-\(userID).json")
        }
    }
}
