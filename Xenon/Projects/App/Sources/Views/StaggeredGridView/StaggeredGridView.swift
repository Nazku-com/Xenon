//
//  StaggeredGridView.swift
//  xenon
//
//  Created by 김수환 on 2/3/25.
//

import SwiftUI
import Translation
import UIComponent

struct StaggeredGridView<Model: StaggeredGridViewModelType>: View {
    
    @ObservedObject private var model: Model
    @State var anchorID: String?
    @State var translateText = ""
    @State var isPresented = false
    @Environment(RouterPath.self) private var routerPath
    
    public var body: some View {
        if #available(iOS 17.4, *) {
            contentView
                .translationPresentation(isPresented: $isPresented, text: translateText)
        } else {
            contentView
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        ScrollView {
            contents
                .padding(.vertical, 24)
            ProgressView()
                .opacity(model.isLoading ? 1 : 0)
                .padding(.bottom, 80)
        }
        .scrollPosition(id: $anchorID, anchor: .top)
        .refreshable {
            Task {
                let id = model.items.first?.first?.id
                await model.fetch(fromBottom: false)
                anchorID = id
            }
        }
        .scrollIndicators(.visible)
        .background(Color.Neumorphic.main)
        .task {
            guard model.items.first?.count == 0 else { return }
            await model.fetch(fromBottom: false)
        }
    }
    
    @ViewBuilder var contents: some View {
        if model.items.count > 0 {
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<model.numberOfRows) { index in
                    viewForRow(at: index)
                }
            }
            .padding(.horizontal, 8)
        } else {
            Text("Nothing here now") // TODO: -
                .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private func viewForRow(at index: Int) -> some View {
        if model.items.count > index {
            LazyVStack {
                ForEach(model.items[index], id:\.id) { content in
                    content.view(routerPath: _routerPath)
                        .onTapGesture {
                            routerPath.path.append(Notification(name: .NeedNavigationNotification, object: content))
                        }
                        .contextMenu {
                            VStack {
                                content.contextMenu
                                Button {
                                    translateText = content.contentString.parseHTML()?.string ?? ""
                                    isPresented.toggle()
                                } label: {
                                    Text("translate")
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .onAppear {
                            let isLast = content.id == model.items[index].last?.id ?? ""
                            if isLast {
                                Task { @MainActor in
                                    await model.fetch(fromBottom: true)
                                }
                            }
                        }
                }
            }
        }
    }
    
    public init(model: Model) {
        self.model = model
        Task {
            await model.fetch(fromBottom: false)
        }
    }
}

extension Notification.Name {
    
    static let NeedNavigationNotification = Notification.Name("NeedNavigationNotification")
}
