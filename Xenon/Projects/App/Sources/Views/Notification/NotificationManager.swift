//
//  NotificationManager.swift
//  xenon
//
//  Created by 김수환 on 3/3/25.
//

import SwiftUI
import FediverseFeature
import UIComponent

final class NotificationManager: FetchableModelType {
    
    static let shared = NotificationManager()
    
    private init() {}
    
    var isLoading: Bool = false
    
    @MainActor
    func fetch(fromBottom: Bool) async {
        guard !isLoading else { return }
        isLoading = true
        let result = await OAuthDataManager.shared.currentOAuthData?.notifications()
        switch result {
        case .success(let notifications):
            let grouped = Dictionary(grouping: notifications, by: { $0.type })
            self.notifications = grouped
            isLoading = false
        default:
            print("Error Occurs to fetch notifications")
            isLoading = false
        }
    }
    
    @Published var notifications = [FediverseNotificationEntity.NotificationType: [FediverseNotificationEntity]]()
}
