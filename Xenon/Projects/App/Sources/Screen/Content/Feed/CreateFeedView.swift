//
//  CreateFeedView.swift
//  xenon
//
//  Created by Claude on 2/1/26.
//

import SwiftUI
import FediverseFeature
import UIComponent

struct CreateFeedView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var selectedTimeline: TimelineOption = .home
    @State private var columns: Int = 1
    @State private var hashtagText: String = ""

    let onAdd: (String, TimelineType, Int) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Feed name", text: $title)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }

                Section("Timeline") {
                    Picker("Type", selection: $selectedTimeline) {
                        ForEach(TimelineOption.allCases) { option in
                            Text(option.displayName).tag(option)
                        }
                    }
                    .pickerStyle(.menu)

                    if selectedTimeline == .hashtag {
                        TextField("Hashtag (without #)", text: $hashtagText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }
                }

                Section("Layout") {
                    Stepper("Columns: \(columns)", value: $columns, in: 1...3)
                }
            }
            .navigationTitle("New Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let feedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !feedTitle.isEmpty else { return }
                        onAdd(feedTitle, selectedTimeline.toTimelineType(hashtag: hashtagText), columns)
                        dismiss()
                    }
                    .disabled(isAddDisabled)
                }
            }
            .onChange(of: selectedTimeline) {
                if title.isEmpty || TimelineOption.allCases.map(\.displayName).contains(title) {
                    title = selectedTimeline.displayName
                }
            }
            .onAppear {
                title = selectedTimeline.displayName
            }
        }
    }

    private var isAddDisabled: Bool {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return true }
        if selectedTimeline == .hashtag && hashtagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return true }
        return false
    }
}

// MARK: - TimelineOption

private enum TimelineOption: String, CaseIterable, Identifiable {

    case home
    case federated
    case trending
    case hashtag

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .home: "Home"
        case .federated: "Federated"
        case .trending: "Trending"
        case .hashtag: "Hashtag"
        }
    }

    func toTimelineType(hashtag: String) -> TimelineType {
        switch self {
        case .home: .home
        case .federated: .federated
        case .trending: .tranding
        case .hashtag: .hashtag(tag: hashtag.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }
}
