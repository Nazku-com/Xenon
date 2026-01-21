//
//  NotificationsView.swift
//  xenon
//
//  Created by 김수환 on 12/24/25.
//

import SwiftUI
import Sugar
import FediverseFeature
import UIComponent

struct NotificationsView: View {
    
    @State private var model: NotificationsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(model.notifications) { notificaion in
                    ContentCell(
                        content: notificaion.status?.content ?? "",
                        date: notificaion.createdAt,
                        buttons: [],
                        emojis: notificaion.status?.emojis.toRemoteEmojies ?? [],
                        header: {
                            AccountHeaderView(account: notificaion.account)
                        }
                    ).onAppear {
                        if notificaion.id == model.notifications.last?.id {
                            Task {
                                await model.loadMore()
                            }
                        }
                    }
                }
                if model.isLoading {
                    ProgressView()
                }
            }
            .padding(.horizontal, 12)
        }.refreshable {
            await model.fetchContents()
        }
        .onFirstAppearTask {
            await model.fetchContents()
        }
    }
    
    init(oAuthdata: OauthData) {
        model = .init(oAuthdata: oAuthdata)
    }
}
