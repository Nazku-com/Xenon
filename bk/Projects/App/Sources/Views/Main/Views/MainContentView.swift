//
//  MainContentView.swift
//  xenon
//
//  Created by 김수환 on 2/19/25.
//

import SwiftUI
import UIComponent
import FediverseFeature

struct MainContentView: View {
    
    let tab: SegmentedControlTab
    @State var needRefresh: Bool = false
    @Binding var path: RouterPath
    @ObservedObject var oAuthDataManager = OAuthDataManager.shared
    @ObservedObject var gridRowNumerManager = GridRowNumerManager.shared
    
    var body: some View {
        contentView
            .onChange(of: oAuthDataManager.currentOAuthData) { _, _ in
                needRefresh.toggle()
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch tab.contentType {
        case .fediverse(let fediverseContentType):
            StaggeredGridView(model: FediverseStaggeredGridViewModel(
                numberOfRows: gridRowNumerManager.numberOfRows,
                timeline: fediverseContentType
            ))
            .environment(path)
        default:
            EmptyView()
        }
    }
}
