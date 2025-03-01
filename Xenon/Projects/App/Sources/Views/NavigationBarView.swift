//
//  NavigationBarView.swift
//  xenon
//
//  Created by 김수환 on 2/23/25.
//

import SwiftUI
import UIComponent

final class NavigationBarViewModel: ObservableObject {
    
    static var shared: NavigationBarViewModel = .init()
    private init() {}
    
    @Published var isAddNoteBarViewShown: Bool = false
}

struct NavigationBarView: View {
    
    @ObservedObject private var model = NavigationBarViewModel.shared
    @Binding var path: NavigationPath
    @Binding var navigationBarModel: NavigationBarModel
    var body: some View {
        VStack {
            if model.isAddNoteBarViewShown {
                AddNoteBarView(lineLimit: 5)
            } else {
                BottomNavigationBar(model: navigationBarModel)
            }
        }
        .animation(.easeInOut, value: model.isAddNoteBarViewShown)
        .onChange(of: path) { _, _ in
            model.isAddNoteBarViewShown = false
        }
    }
}
