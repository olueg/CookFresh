//
//  ChatView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 08.11.26.
//

import SwiftUI
public import Combine


struct ChatView: View {
    @State private var input: String = ""
    
    @AppStorage("FreshCookModel") private var selectedModel: String = ""
    @AppStorage("FreshCookModelDescription") private var selectedModelDescription: String = ""
    @AppStorage("gemini_api_key") private var apiKey: String = ""

    @State private var isGenerating: Bool = false
    @State private var gernerationStart: Date?
    @State private var messages: [ChatMessage] = []
    
    var body: some View {
        VStack(spacing: 0) {
            if isGenerating {
                GeneratingIndicator(
                    isGenerating: $isGenerating,
                    startDate: gernerationStart ?? Date()
                )
            }
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            // Container für TextEditor und integrierten Send-Button (fest am unteren Rand)
            VStack(spacing: 0) {
                HStack(alignment: .bottom, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    if input.isEmpty {
                        Text("Message...")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $input)
                        .font(.body)
                        .lineSpacing(5) // Give more space
                        .frame(minHeight: 40, maxHeight: 120)
                        .scrollContentBackground(.hidden)
                        .padding(8)
                        .background(Color.clear)
                }
                
                

            }

            
            HStack {
                Spacer()
                Text(selectedModelDescription)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                   
                
                Button(action: { Task { await send() } }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(Circle().fill(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.4) : Color.blue))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Send")
                .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.bottom, 6)
                .padding(.trailing, 6)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.quaternarySystemFill))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
        )
        .padding()
    }
    }
    
    private func send() async {
        isGenerating = true
        gernerationStart = Date()
        let prompt = input
        let start = Date()
        input = ""
        messages.append(ChatMessage(role: "user", content: prompt, timestamp: Date()))
        do {
            let result = try await GeminiService.shared.generateContent(
                prompt: prompt,
                model: selectedModel,
                apiKey: apiKey
            )
            let elapsed = Int(Date().timeIntervalSince(start) * 1000)
            messages.append(ChatMessage(role: "assistant", content: result, timestamp: Date(), responseTime: elapsed))
        } catch {
            messages.append(ChatMessage(role: "assistant", content: "Fehler: \(error.localizedDescription)", timestamp: Date()))
        }
        isGenerating = false
    }
}

#Preview {
    ChatView()
}

struct GeneratingIndicator: View {
    @Binding var isGenerating: Bool
    let startDate: Date
    
    @State private var elapsed: TimeInterval = 0
    
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            Image(systemName: "sparkles")
                .foregroundColor(.blue)
                .symbolEffect(.pulse, options: .repeating)
            
            Text("I'm cooking...")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(formattedElapsed)
                .font(.caption)
                .foregroundStyle(.secondary)
                .monospacedDigit()
            
            Spacer()
        }
        .padding(.leading)
        .transition(.opacity.combined(with: .move(edge: .top)))
        .onReceive(ticker) { _ in
            elapsed = Date().timeIntervalSince(startDate)
        }
    }
    
    private var formattedElapsed: String {
        let seconds = Int(elapsed)
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
        
    }
}
