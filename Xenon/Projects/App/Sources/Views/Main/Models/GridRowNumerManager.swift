//
//  GridRowNumerManager.swift
//  xenon
//
//  Created by 김수환 on 2/19/25.
//

import SwiftUI

final class GridRowNumerManager: ObservableObject {
    static let shared = GridRowNumerManager()
    private init() {}
    
    @Published private(set) var numberOfRows = UserDefaults.standard.integer(forKey: Constant.userDefaultsKey)
    
    func updateNumberOfRows(_ newValue: Int) {
        UserDefaults.standard.set(newValue, forKey: Constant.userDefaultsKey)
        numberOfRows = newValue
    }
}

// MARK: - Constant

private extension GridRowNumerManager {
    
    enum Constant {
        
        static let userDefaultsKey = "GridRowNumer"
    }
}
