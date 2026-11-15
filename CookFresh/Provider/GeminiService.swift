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
        let parts: [Part]
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

        let urlString = "https://generativelanguage.googleapis.com/v1beta/\(model):generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }

        let request = GenerateContentRequest(contents: [
            .init(parts: [.init(text: prompt)])
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
}
