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
    
    @State private var isGenerating: Bool = false
    @State private var gernerationStart: Date?
    
    var body: some View {
        Spacer()
        if isGenerating {
            GeneratingIndicator(
                isGenerating: $isGenerating,
                startDate: gernerationStart ?? Date()
            )
        }
        VStack {
            // Container für TextEditor und integrierten Send-Button
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
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.quaternarySystemFill))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
            )
            
            HStack {
                Spacer()
                Text(selectedModelDescription)
                    .font(.caption)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding()
    }
    
    private func send() async {
        isGenerating = true
        gernerationStart = Date()
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
