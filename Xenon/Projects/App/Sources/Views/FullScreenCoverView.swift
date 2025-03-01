//
//  FullScreenCoverView.swift
//  xenon
//
//  Created by 김수환 on 2/22/25.
//

import SwiftUI
import UIComponent

struct FullScreenCoverView: View {
    
    @Binding var contentType: ContentViewModel.Sheet?
    
    var body: some View {
        switch contentType {
        case .addNote:
            addNoteView
        case nil:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var addNoteView: some View {
        VStack {
            HStack {
                Text("cancel")
                    .onTapGesture {
                        ContentViewModel.shared.selectedSheet = nil
                    }
                Spacer()
            }
            Spacer()
            AddNoteBarView(lineLimit: nil)
        }
        .background(Color.Neumorphic.main)
    }
}

#Preview {
    FullScreenCoverView(contentType: .constant(.addNote))
}
