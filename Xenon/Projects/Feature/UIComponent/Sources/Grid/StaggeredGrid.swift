//
//  StaggeredGrid.swift
//  UIComponent
//
//  Created by 김수환 on 10/29/25.
//  Copyright © 2025 social.xenon. All rights reserved.
//

import SwiftUI
import Translation

public struct StaggeredGridView<T: Identifiable, Cell: View>: View {
    
    var items: [[T]]
    let columns: Int
    let refreshable: () async -> Void
    let loadMore: (T) async -> Void
    let cell: (T) -> Cell
    @Binding var anchorID: String?
    @Binding var isloading: Bool
    
    public var body: some View {
        contentView
    }
    
    @ViewBuilder
    private var contentView: some View {
        ScrollView {
            contents
                .scrollTargetLayout()
                .padding(.vertical, 24)
                .padding(.horizontal, 12)
        }
        .scrollTargetBehavior(.viewAligned)
        .refreshable {
            Task {
                await refreshable()
            }
        }
        .scrollPosition(id: $anchorID, anchor: .top)
        .scrollIndicators(.visible)
    }
    
    @ViewBuilder var contents: some View {
        if items.count > 0 {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<columns) { column in
                    viewForRow(at: column)
                }
            }
        } else {
            if isloading {
                ProgressView()
            } else {
                Text("Nothing here now") // TODO: -
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    @ViewBuilder
    private func viewForRow(at column: Int) -> some View {
        if items.count > column {
            LazyVStack {
                ForEach(items[column], id: \.id) { content in
                    cell(content)
                        .onAppear {
                            if content.id == items[column].last!.id {
                                Task {
                                    await loadMore(content)
                                }
                            }
                        }
                }
                if isloading {
                    ProgressView()
                }
            }
        }
    }
    
    public init(
        items: [[T]],
        columns: Int,
        cell: @escaping (T) -> Cell,
        refreshable: @escaping () async -> Void,
        loadMore: @escaping (T) async -> Void,
        anchorID: Binding<String?>,
        isloading: Binding<Bool>
    ) {
        self.items = items
        self.columns = columns
        self.cell = cell
        self.refreshable = refreshable
        self.loadMore = loadMore
        _anchorID = anchorID
        _isloading = isloading
    }
}
