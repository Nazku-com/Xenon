//
//  SideBarDisplayViewModel.swift
//  xenon
//
//  Created by 김수환 on 2/19/25.
//

import SwiftUI

final class SideBarDisplayViewModel: ObservableObject {
    
    @Published var isSheetPresented: Bool = false
    @Published var badgeCount: Int = 0
    
    @Published var selectedSheet: Sheet? {
        didSet {
            isSheetPresented = selectedSheet != nil
        }
    }
    
    init() {
        Task { @MainActor in
            let result = await OAuthDataManager.shared.currentOAuthData?.followRequest()
            switch result {
            case .success(let success):
                badgeCount = success.count
            case .failure, .none:
                badgeCount = 0
                return // TODO: -
            }
        }
    }
    
    enum Sheet {
        
        case identifier
        case setting
    }
}
