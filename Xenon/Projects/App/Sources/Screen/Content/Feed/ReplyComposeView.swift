//
//  ReplyComposeView.swift
//  xenon
//
//  Created by Claude on 2/1/26.
//

import SwiftUI
import FediverseFeature
import UIComponent
import EmojiText

struct ReplyComposeView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var replyText: String = ""
    @State private var isPosting: Bool = false
    @FocusState private var isFocused: Bool

    let replyTo: FediverseResponseEntity
    let oAuthData: OauthData?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                replyingToView
                Divider()
                TextEditor(text: $replyText)
                    .font(.styled(.body))
                    .focused($isFocused)
                    .frame(minHeight: 120)
                Spacer()
            }
            .padding()
            .navigationTitle("Reply")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        postReply()
                    } label: {
                        if isPosting {
                            ProgressView()
                        } else {
                            Text("Post")
                                .bold()
                        }
                    }
                    .disabled(replyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPosting)
                }
            }
            .onAppear {
                let mentions = buildMentionPrefix()
                if !mentions.isEmpty {
                    replyText = mentions
                }
                isFocused = true
            }
        }
    }

    @ViewBuilder
    private var replyingToView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("Replying to")
                    .font(.styled(.caption))
                    .foregroundStyle(.secondary)
                Text("@\(replyTo.account.acct)")
                    .font(.styled(.caption))
                    .foregroundStyle(.blue)
            }
            Text(replyTo.content)
                .font(.styled(.caption))
                .foregroundStyle(.secondary)
                .lineLimit(3)
        }
    }

    private func buildMentionPrefix() -> String {
        var mentions = ["@\(replyTo.account.acct)"]
        for mention in replyTo.mentions {
            let acct = mention.acct
            if !mentions.contains("@\(acct)") {
                mentions.append("@\(acct)")
            }
        }
        return mentions.joined(separator: " ") + " "
    }

    private func postReply() {
        guard let oAuthData, !replyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isPosting = true
        Task {
            let result = await oAuthData.postStatus(
                status: replyText,
                inReplyToID: replyTo.id,
                visibility: replyTo.visibility
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
