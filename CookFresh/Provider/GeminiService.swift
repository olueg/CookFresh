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
}
