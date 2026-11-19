//
//  MessageBubble.swift
//  CookFresh
//
//  Created by Olaf Lueg on 08.11.26.
//

import SwiftUI
import AppKit
import MarkdownUI

struct MessageBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if message.role == "user" { Spacer(minLength: 40) }

            VStack(alignment: message.role == "user" ? .trailing : .leading, spacing: 4) {
                if !(message.content?.isEmpty ?? true) {
                    Markdown(message.content ?? "")
                        .padding(10)
                        .background(message.role == "user" ? Color.accentColor.opacity(0.2) : Color.gray.opacity(0.15))
                        .clipShape(.rect(cornerRadius: 12))
                        .textSelection(.enabled)
                }

                if message.role == "assistant", let responseTime = message.responseTime, !(message.content?.isEmpty ?? true) {
                    HStack(spacing: 15) {
                        Button(action: { copyText(message.content ?? "") }) {
                            Image(systemName: "doc.on.doc")
                                .font(.caption2)
                        }
                        .buttonStyle(.plain)
                        .help("Antwort kopieren")

                        // Response Time in Minuten und Sekunden
                        Text(formatResponseTime(responseTime))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(responseTime < 500 ? .green : (responseTime >= 1500 ? .red : .orange))
                            .help("\(responseTime)ms Response Time")

                        Button(action: thumUp) {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        .help("Gute Antwort")

                        Button(action: thumDown) {
                            Image(systemName: "hand.thumbsdown.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                        .help("Schlechte Antwort")

                    }
                    .padding(.horizontal, 5)
                }
            }

            if message.role != "user" { Spacer(minLength: 40) }
        }
    }

    // MARK: - Helpers

    private func markdownAttributed(_ text: String) -> AttributedString {
        (try? AttributedString(markdown: text)) ?? AttributedString(text)
    }

    private func copyText(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    private func thumUp() {
        // Placeholder: hook up feedback handling here.
    }

    private func thumDown() {
        // Placeholder: hook up feedback handling here.
    }

    private func formatResponseTime(_ ms: Int) -> String {
        let seconds = Double(ms) / 1000.0
        if seconds < 60 {
            return String(format: "%.1fs", seconds)
        }
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return "\(minutes)m \(remainingSeconds)s"
    }
}

#Preview {
    MessageBubble(message: ChatMessage(role: "assistant", content: "Hello **world**!", responseTime: 1200))
}
