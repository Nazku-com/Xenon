//
//  PathManager.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import SwiftUI

final class PathManager: ObservableObject {
    
    static let shared = PathManager()
    
    private init() {}
    
    var path: NavigationPath {
        load(from: currentTab)
    }
    
    private var currentTab: MainTab = .home
    
    func updateTab(_ tab: MainTab, path: NavigationPath) {
        save(currentPath: path, to: currentTab)
        currentTab = tab
    }
    
    private var pathDictionary = [MainTab: NavigationPath]()
    
    private func save(currentPath: NavigationPath, to tab: MainTab) {
        pathDictionary[tab] = currentPath
    }
    
    private func load(from tab: MainTab) -> NavigationPath {
        pathDictionary[tab] ?? NavigationPath()
    }
}
