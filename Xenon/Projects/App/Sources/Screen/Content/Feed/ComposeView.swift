//
//  ComposeView.swift
//  xenon
//
//  Created by Claude on 2/1/26.
//

import SwiftUI
import FediverseFeature
import UIComponent

struct ComposeView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var statusText: String = ""
    @State private var isPosting: Bool = false
    @State private var selectedVisibility: FediverseResponseEntity.Visibility = .public
    @FocusState private var isFocused: Bool

    let oAuthData: OauthData?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                TextEditor(text: $statusText)
                    .font(.styled(.body))
                    .focused($isFocused)
                    .frame(minHeight: 160)

                Divider()

                HStack {
                    visibilityPicker
                    Spacer()
                    Text("\(statusText.count)")
                        .font(.styled(.caption))
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        postStatus()
                    } label: {
                        if isPosting {
                            ProgressView()
                        } else {
                            Text("Post")
                                .bold()
                        }
                    }
                    .disabled(statusText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPosting)
                }
            }
            .onAppear {
                isFocused = true
            }
        }
    }

    @ViewBuilder
    private var visibilityPicker: some View {
        Menu {
            ForEach(visibilityOptions, id: \.self) { visibility in
                Button {
                    selectedVisibility = visibility
                } label: {
                    Label(visibility.displayName, systemImage: visibility.iconName)
                }
            }
        } label: {
            Label(selectedVisibility.displayName, systemImage: selectedVisibility.iconName)
                .font(.styled(.caption))
        }
    }

    private var visibilityOptions: [FediverseResponseEntity.Visibility] {
        [.public, .unlisted, .private, .direct]
    }

    private func postStatus() {
        guard let oAuthData, !statusText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isPosting = true
        Task {
            let result = await oAuthData.postStatus(
                status: statusText,
                visibility: selectedVisibility
            )
            switch result {
            case .success:
                await MainActor.run {
                    dismiss()
                }
            case .failure(let error):
                print(error) // swiftlint:disable:this no_print
                // TODO: - Show error to user
            }
            isPosting = false
        }
    }
}

// MARK: - Visibility Helpers

private extension FediverseResponseEntity.Visibility {

    var displayName: String {
        switch self {
        case .public: "Public"
        case .unlisted: "Unlisted"
        case .private: "Followers Only"
        case .direct: "Direct"
        case .unknwon: "Unknown"
        }
    }

    var iconName: String {
        switch self {
        case .public: "globe"
        case .unlisted: "lock.open"
        case .private: "lock"
        case .direct: "envelope"
        case .unknwon: "questionmark.circle"
        }
    }
}
