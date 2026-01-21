//
//  FeedView.swift
//  xenon
//
//  Created by 김수환 on 10/26/25.
//

import SwiftUI
import Combine
import Sugar
import FediverseFeature
import UIComponent
import EmojiText

struct FeedView: View {
    
    @Environment(MainViewModel.self) private var mainViewModel
    @Namespace private var namespace
    @State private var model: FeedViewModel
    
    init(model: FeedViewModel) {
        self.model = model
    }
    
    var body: some View {
        StaggeredGridView(
            items: model.items,
            columns: model.columns,
            cell: { content in
                FeedCell(content: content)
                    .environment(mainViewModel)
                    .frame(maxHeight: 400)
            },
            refreshable: {
                let id = model.timelineData.first?.id
                await model.loadNew()
                model.anchorID = id
            },
            loadMore: { content in
                await model.loadMore()
            },
            anchorID: $model.anchorID,
            isloading: $model.isLoading
        )
        .onFirstAppearTask {
            await model.fetchContents()
        }
    }
}
