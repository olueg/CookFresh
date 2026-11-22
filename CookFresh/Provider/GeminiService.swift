//
//  GeminiService.swift
//  CookFresh
//
//  Created by Olaf Lueg on 07.11.26.
//

import Foundation

struct GeminiModelsResponse: Codable {
    let models: [GeminiModel]
}

// MARK: - Generate Content

struct GenerateContentRequest: Codable {
    struct Content: Codable {
        struct Part: Codable {
            let text: String
        }
        let role: String?
        let parts: [Part]

        init(role: String? = nil, parts: [Part]) {
            self.role = role
            self.parts = parts
        }
    }
    let contents: [Content]
}

struct GenerateContentResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String?
            }
            let parts: [Part]?
        }
        let content: Content?
    }
    let candidates: [Candidate]?
}

struct GeminiModel: Codable, Identifiable, Hashable {
    var id: String {name}
    let name: String
    let displayName: String?
    let description: String?
    let inputTokenLimit: Int?
    let outputTokenLimit: Int?
    let supportedGenerationMethods: [String]
}





@MainActor
@Observable
class GeminiService {
    static let shared = GeminiService()
    
    
    
    // Get a list of available models
    func fetchGeminiModels(apiKey: String) async throws -> [GeminiModel] {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models?key=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedResponse = try JSONDecoder().decode(GeminiModelsResponse.self, from: data)
        print(decodedResponse.self)
            return decodedResponse.models
    }

    /// Generates a text response for the given prompt using the specified model.
    func generateContent(prompt: String, model: String, apiKey: String) async throws -> String {
        guard !apiKey.isEmpty else { throw URLError(.userAuthenticationRequired) }
        guard !model.isEmpty else { throw URLError(.badURL) }
        let resolvedModel = model.hasPrefix("models/") ? model : "models/\(model)"

        let urlString = "https://generativelanguage.googleapis.com/v1beta/\(resolvedModel):generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let request = GenerateContentRequest(contents: [
            .init(role: "user", parts: [.init(text: prompt)])
        ])

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard httpResponse.statusCode == 200 else {
            let body = String(data: data, encoding: .utf8) ?? "<no body>"
            print("Gemini API error \(httpResponse.statusCode): \(body)")
            throw NSError(domain: "GeminiService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP \(httpResponse.statusCode): \(body)"])
        }

        let decoded = try JSONDecoder().decode(GenerateContentResponse.self, from: data)
        return decoded.candidates?.first?.content?.parts?.first?.text ?? ""
    }

    /// Streams a text response for the given prompt, yielding incremental text chunks.
    func generateContentStream(prompt: String, model: String, apiKey: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    guard !apiKey.isEmpty else { throw URLError(.userAuthenticationRequired) }
                    guard !model.isEmpty else { throw URLError(.badURL) }
        let resolvedModel = model.hasPrefix("models/") ? model : "models/\(model)"

                    let urlString = "https://generativelanguage.googleapis.com/v1beta/\(resolvedModel):streamGenerateContent?alt=sse&key=\(apiKey)"
                    guard let url = URL(string: urlString) else { throw URLError(.badURL) }

                    let request = GenerateContentRequest(contents: [
                        .init(role: "user", parts: [.init(text: prompt)])
                    ])

                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "POST"
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    urlRequest.httpBody = try JSONEncoder().encode(request)

                    let (bytes, response) = try await URLSession.shared.bytes(for: urlRequest)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }

                    for try await line in bytes.lines {
                        let trimmed = line.trimmingCharacters(in: .whitespaces)
                        guard trimmed.hasPrefix("data:") else { continue }
                        let payload = String(trimmed.dropFirst(5)).trimmingCharacters(in: .whitespaces)
                        if payload.isEmpty || payload == "[DONE]" { continue }
                        if let data = payload.data(using: .utf8),
                           let decoded = try? JSONDecoder().decode(GenerateContentResponse.self, from: data),
                           let text = decoded.candidates?.first?.content?.parts?.first?.text {
                            continuation.yield(text)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    /// Streams a text response using the full conversation history for context.
    func generateContentStream(history: [ChatMessage], model: String, apiKey: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    guard !apiKey.isEmpty else { throw URLError(.userAuthenticationRequired) }
                    guard !model.isEmpty else { throw URLError(.badURL) }
        let resolvedModel = model.hasPrefix("models/") ? model : "models/\(model)"

                    let contents = history.compactMap { message -> GenerateContentRequest.Content? in
                        guard let text = message.content, !text.isEmpty else { return nil }
                        let role = (message.role == "user") ? "user" : "model"
                        return .init(role: role, parts: [.init(text: text)])
                    }

                    let urlString = "https://generativelanguage.googleapis.com/v1beta/\(resolvedModel):streamGenerateContent?alt=sse&key=\(apiKey)"
                    guard let url = URL(string: urlString) else { throw URLError(.badURL) }

                    let request = GenerateContentRequest(contents: contents)

                    var urlRequest = URLRequest(url: url)
                    urlRequest.httpMethod = "POST"
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    urlRequest.httpBody = try JSONEncoder().encode(request)

                    let (bytes, response) = try await URLSession.shared.bytes(for: urlRequest)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }

                    for try await line in bytes.lines {
                        let trimmed = line.trimmingCharacters(in: .whitespaces)
                        guard trimmed.hasPrefix("data:") else { continue }
                        let payload = String(trimmed.dropFirst(5)).trimmingCharacters(in: .whitespaces)
                        if payload.isEmpty || payload == "[DONE]" { continue }
                        if let data = payload.data(using: .utf8),
                           let decoded = try? JSONDecoder().decode(GenerateContentResponse.self, from: data),
                           let text = decoded.candidates?.first?.content?.parts?.first?.text {
                            continuation.yield(text)
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
