//
//  ChatMessage.swift
//  CookFresh
//
//  Created by Olaf Lueg on 06.11.26.
//


import Foundation
import SwiftData



@Model
final class ChatMessage {
    var id: UUID = UUID()
    var role: String?
    var content: String?
    var timestamp: Date?
    var session: ChatSession?
    var responseTime: Int? // in millisecond (only for assistant)

    init(role: String? = nil, content: String? = nil, timestamp: Date? = nil, session: ChatSession? = nil, responseTime: Int? = nil) {
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.session = session
        self.responseTime = responseTime
    }
}
