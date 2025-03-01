//
//  SideBarDisplayViewModel.swift
//  xenon
//
//  Created by 김수환 on 2/19/25.
//

import SwiftUI

final class SideBarDisplayViewModel: ObservableObject {
    
    @Published var isSheetPresented: Bool = false
    
    @Published var selectedSheet: Sheet? {
        didSet {
            isSheetPresented = selectedSheet != nil
        }
    }
    
    enum Sheet {
        
        case identifier
        case setting
    }
}
