//
//  ContentViewModel.swift
//  xenon
//
//  Created by 김수환 on 2/22/25.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    
    static var shared = ContentViewModel()
    private init() {}
    
    @Published var isSheetPresented: Bool = false
    
    @Published var selectedSheet: Sheet? {
        didSet {
            isSheetPresented = selectedSheet != nil
        }
    }
    
    enum Sheet {
        
        case addNote
    }
}
