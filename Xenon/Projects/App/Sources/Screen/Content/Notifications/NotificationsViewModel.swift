//
//  NotificationsViewModel.swift
//  xenon
//
//  Created by 김수환 on 12/27/25.
//

import SwiftUI
import FediverseFeature
import Combine

@Observable
@MainActor
final class NotificationsViewModel {
    
    var notifications: [FediverseNotificationEntity] = []
    var isLoading: Bool = false
    @ObservationIgnored var pagenation: (next: URL?, prev: URL?)
    private let oAuthdata: OauthData
    
    init(oAuthdata: OauthData) {
        self.oAuthdata = oAuthdata
    }
    
    func fetchContents() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let result = await oAuthdata.notifications()
        switch result {
        case .success(let success):
            notifications = success.data
            if let pagenation = (success.urlResponse as? HTTPURLResponse)?.pagenation {
                self.pagenation = pagenation
            }
        case .failure(let failure):
            print(failure)
        }
    }
    
    func loadMore() async {
        guard
            !isLoading,
            let nextURL = pagenation.next
        else {
            return
        }
        isLoading = true
        defer { isLoading = false }
        let result = await oAuthdata.notifications(pagenationURL: nextURL)
        switch result {
        case .success(let success):
            notifications.append(contentsOf: success.data)
            if let pagenation = (success.urlResponse as? HTTPURLResponse)?.pagenation {
                self.pagenation = pagenation
            }
        case .failure(let failure):
            print(failure)
        }
    }
}
