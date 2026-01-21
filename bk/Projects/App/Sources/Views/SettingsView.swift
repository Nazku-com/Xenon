//
//  SettingsView.swift
//  xenon
//
//  Created by 김수환 on 3/1/25.
//

import SwiftUI

struct SettingsView: View {
    
    let contents: [SettingContent] = SettingContent.default
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(contents) { content in
                    Section {
                        ForEach(content.contents) { contentData in
                            NavigationLink {
                                contentData.view
                            } label: {
                                Text(contentData.title)
                            }
                        }
                    } header: {
                        Text(content.header)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    struct SettingContent: Identifiable {
        var id = UUID()
        let header: String
        let contents: [SettingContentData]
        
        struct SettingContentData: Identifiable {
            var id = UUID()
            let title: String
            var view: AnyView
        }
        
        static let `default`: [SettingContent] = [
            .init(header: "timeline", contents: [
                .init(title: "edit timeline", view: .init(EditTimelineView())),
                .init(title: "sensitive content", view: .init(SensitiveContentToggleView()))
            ]),
        ]
    }
}

#Preview {
    SettingsView()
}
