//
//  NavigationBarView.swift
//  xenon
//
//  Created by 김수환 on 2/23/25.
//

import SwiftUI
import UIComponent

struct NavigationBarView: View {
    
    @Binding var navigationBarModel: NavigationBarModel
    var body: some View {
        BottomNavigationBar(model: navigationBarModel)
    }
}
