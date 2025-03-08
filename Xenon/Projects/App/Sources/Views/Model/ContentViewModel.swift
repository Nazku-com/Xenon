//
//  ContentViewModel.swift
//  xenon
//
//  Created by 김수환 on 3/8/25.
//

import SwiftUI
import UIComponent

final class ContentViewModel: ObservableObject {
    
    @Published var selectedTab: String = MainTab.home.rawValue
}
