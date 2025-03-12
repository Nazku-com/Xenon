//
//  FediverseAccountDetailView.swift
//  xenon
//
//  Created by 김수환 on 3/9/25.
//

import SwiftUI
import UIComponent
import FediverseFeature

struct FediverseAccountDetailView: View {
    
    @ObservedObject var model: FediverseAccountDetailViewModel
    @State var width: CGFloat
    @Environment(RouterPath.self) private var routerPath

    var body: some View {
        VStack {
            if model.items.count > 0 {
                ForEach(model.items) { content in
                    ContentCellView(
                        content: content,
                        contentLineLimit: nil,
                        hideContents: !SensitiveContentManager.shared.hideWarning && content.sensitive
                    ) {
                        EmptyView()
                    } onAvatarTapped: { account in
                        routerPath.path.append(NavigationType.userAccountInfo(account)) // TODO: - exception handle(do not move to same account Detail View)
                    }
                    .onTapGesture {
                        routerPath.path.append(Notification(name: .NeedNavigationNotification, object: content)) // TODO: -
                    }
                }
                if model.isLoading {
                    ProgressView()
                } else {
                    Button {
                        Task {
                            await model.fetch(fromBottom: true)
                        }
                    } label: {
                        Text("load more")
                    }
                }
            } else if !model.didFetched {
                ProgressView()
                    .frame(height: 80)
            } else {
                EmptyView()
            }
        }
        .frame(width: width)
        .task {
            await model.fetch(fromBottom: false)
        }
        .onRotate { orientation in
            let size = UIScreen.main.bounds.size
            self.width = orientation.isLandscape ? max(size.width, size.height) : min(size.width, size.height)
        }
    }
    
    init(model: FediverseAccountDetailViewModel) {
        self.model = model
        self.width = UIScreen.main.bounds.width
    }
}
