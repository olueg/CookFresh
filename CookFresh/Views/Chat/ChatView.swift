//
//  ChatView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 08.11.26.
//

import SwiftUI

struct ChatView: View {
    @State private var input: String = ""
    @State private var isAnimating = false
    @AppStorage("FreshCookModel") private var selectedModel: String = ""
    @AppStorage("FreshCookModelDescription") private var selectedModelDescription: String = ""
    
    @State private var isGenerating: Bool = false
    
    var body: some View {
        Spacer()

        if isGenerating {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                    .scaleEffect(isAnimating ? 1.2 : 0.9)
                    .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("I'm cooking...")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding(.leading)
            .transition(.opacity.combined(with: .move(edge: .top)))
            .onAppear {
                isAnimating = true
            }
        }

        VStack {
            // Container für TextEditor und integrierten Send-Button
            HStack(alignment: .bottom, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    if input.isEmpty {
                        Text("Message...")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                    }
                    TextEditor(text: $input)
                        .frame(minHeight: 40, maxHeight: 120)
                        .scrollContentBackground(.hidden)
                        .padding(4)
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
        isGenerating.toggle()
    }
}

#Preview {
    ChatView()
}
