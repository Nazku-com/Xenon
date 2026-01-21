//
//  MainViewModel.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import SwiftUI
import FediverseFeature

final class MainViewModel: ObservableObject {
    
    let oAuthData: OauthData
    @Published var selectedTab: String
    @Published var tabs: [SegmentedControlTab]
    
    init(oAuthData: OauthData) {
        self.oAuthData = oAuthData
        let tabs = SegmentedControlTabManager.shared.tabs(for: oAuthData.user?.id)
        self.tabs = tabs
        self.selectedTab = tabs.first?.title ?? ""
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didRecieveNeedRefreshSegmentControl),
            name: .NeedRefreshSegmentControl,
            object: nil
        )
    }
    
    @objc
    private func didRecieveNeedRefreshSegmentControl() {
        let tabs = SegmentedControlTabManager.shared.tabs(for: oAuthData.user?.id)
        self.tabs = tabs
    }
}
