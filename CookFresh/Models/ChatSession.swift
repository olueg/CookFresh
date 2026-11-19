//
//  ChatSession.swift
//  CookFresh
//
//  Created by Olaf Lueg on 06.11.26.
//


import Foundation
import SwiftData

@Model
final class ChatSession {
    var id: UUID = UUID()
    var title: String?
    var createdAt: Date?
    @Relationship(deleteRule: .cascade, inverse: \ChatMessage.session)
    var messages: [ChatMessage] = []

    init(title: String? = nil, createdAt: Date? = nil) {
        self.title = title
        self.createdAt = createdAt
    }
}