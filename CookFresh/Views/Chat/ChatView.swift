//
//  ChatView.swift
//  CookFresh
//
//  Created by Olaf Lueg on 08.11.26.
//

import SwiftUI
import SwiftData
public import Combine


struct ChatView: View {
    @Binding var selectedSession: ChatSession?
    @Environment(\.modelContext) private var modelContext

    @State private var input: String = ""
    

    @AppStorage("FreshCookModel") private var selectedModel: String = ""
    @AppStorage("FreshCookModelDescription") private var selectedModelDescription: String = ""
    @AppStorage("gemini_api_key") private var apiKey: String = ""

    @State private var isGenerating: Bool = false
    @State private var gernerationStart: Date?
    @State private var showError: Bool = false
    @State private var errorText: String = ""
    @State private var brain = KitchenBrain(geminiAPIKey: UserDefaults.standard.string(forKey: "gemini_api_key"))
    
    var body: some View {
        
        VStack(spacing: 0) {
            if selectedSession == nil {
                VStack {
                    Spacer()
                    Text("Wähle oder erstelle eine Session")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            } else {
                // ScrollViewReader ermöglicht das Automatische scrollen an das ende
                ScrollViewReader{ proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(selectedSession?.messages ?? []) { message in
                                MessageBubble(message: message)
                            }
                            // Unsichtbarer Anker am Ende des ScrollView
                            Color.clear
                                .frame(height: 1)
                                .id("bottom")
                        }
                        .padding()
                    }
                    // WICHTIG: Wir triggern auf beides: Anzahl Nachrichten ODER Generierungs-Status
                    .onChange(of: selectedSession?.messages.count) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                    .onChange(of: isGenerating) {
                        if isGenerating {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                    // Falls das während des Streamings noch stockt, füge das hier hinzu:
                    .onChange(of: selectedSession?.messages.last?.content) {
                        if isGenerating {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
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
                if isGenerating {
                    GeneratingIndicator(
                        isGenerating: $isGenerating,
                        startDate: gernerationStart ?? Date()
                    )
                }
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
        guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        // Ensure a session exists
        if selectedSession == nil {
            let newSession = ChatSession(title: "New Chat", createdAt: Date())
            modelContext.insert(newSession)
            try? modelContext.save()
            selectedSession = newSession
        }
        guard let session = selectedSession else { return }

        isGenerating = true
        gernerationStart = Date()
        let prompt = input
        let start = Date()
        input = ""

        let userMessage = ChatMessage(role: "user", content: prompt, timestamp: Date(), session: session)
        modelContext.insert(userMessage)
        session.messages.append(userMessage)
        try? modelContext.save()

        let assistantMessage = ChatMessage(role: "assistant", content: "", timestamp: Date(), session: session)
        modelContext.insert(assistantMessage)
        session.messages.append(assistantMessage)
        try? modelContext.save()

        do {
            // Hier nutzen wir den KitchenBrain, der sich um Hybrid-Routing & Gedächtnis kümmert
            let result = try await brain.askAssistant(prompt: prompt, modelContext: modelContext)
            
            // Antwort verarbeiten
            assistantMessage.content = result.mainCourseTitle + "\n\n" + result.explanation
            try? modelContext.save()
            let elapsed = Int(Date().timeIntervalSince(start) * 1000)
            assistantMessage.responseTime = elapsed
            try? modelContext.save()
            
        } catch {
            print("ChatView send error: \(error)")
            assistantMessage.content = "Fehler: \(error.localizedDescription)"
            try? modelContext.save()
        }
        
        /* ersetzt durch KitchenBrain
        do {
            let history = session.messages.filter { !($0.content?.isEmpty ?? true) }
            let stream = GeminiService.shared.generateContentStream(
                history: history,
                model: selectedModel,
                apiKey: apiKey
            )
            var accumulated = ""
            for try await chunk in stream {
                accumulated += chunk
                assistantMessage.content = accumulated
                try? modelContext.save()
            }
            let elapsed = Int(Date().timeIntervalSince(start) * 1000)
            assistantMessage.responseTime = elapsed
            try? modelContext.save()

            // Auto-title from first user message
            if session.title == "New Chat" || session.title == nil {
                session.title = String(prompt.prefix(40))
                try? modelContext.save()
            }
        } catch {
            assistantMessage.content = "Fehler: \(error.localizedDescription)"
            try? modelContext.save()
        }
         */
        isGenerating = false
    }
}

#Preview {
    @Previewable @State var selectedSession: ChatSession? = nil
    ChatView(selectedSession: $selectedSession)
        .modelContainer(for: ChatSession.self, inMemory: true)
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

