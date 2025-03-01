//
//  AddNoteBarView.swift
//  xenon
//
//  Created by 김수환 on 2/22/25.
//

import SwiftUI
import UIComponent

struct AddNoteBarView: View {
    
    @State var text: String = ""
    @FocusState private var isFocused: Bool
    
    let lineLimit: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            Button {
                NavigationBarViewModel.shared.isAddNoteBarViewShown = false
            } label: {
                Text("cancel")
            }
            HStack(alignment: .bottom, spacing: 8) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                }
                .softButtonStyle(Circle(), padding: 8)
                .frame(width: 32, height: 32)
                
                TextField(
                    "Type here...",
                    text: $text,
                    axis: .vertical
                )
                .focused($isFocused)
                .lineSpacing(10.0)
                .foregroundStyle(.primary)
                .lineLimit(lineLimit ?? .max)
                .padding(4)
                .background {
                    NeumorphicBackgroundView(isInnerShadowEnabled: true)
                }
                
                Button {
                    Task {
                        _ = await OAuthDataManager.shared.currentOAuthData?.post(content: text, visibility: .public)
                        text = ""
                        NavigationBarViewModel.shared.isAddNoteBarViewShown = false
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .softButtonStyle(Circle(), padding: 8)
                .frame(width: 32, height: 32)
            }
        }
        .padding(8)
        .onAppear {
            SideBarViewModel.shared.sideBarOpenablePublisher.send(false)
            isFocused = true
        }
        .onDisappear {
            SideBarViewModel.shared.sideBarOpenablePublisher.send(true)
        }
        .transition(
            .asymmetric(
                insertion: .push(from: .bottom),
                removal: .push(from: .top)
            )
        )
    }
}

#Preview {
    AddNoteBarView(lineLimit: nil)
}
