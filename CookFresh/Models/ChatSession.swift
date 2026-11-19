/*
                       ChatSession.swift  -  description
                          -------------------
 begin                : Fri Nov  6 2026
 copyright            : (C) 2026 by Olaf Lueg
 discussions          : https://github.com/olueg/CookFresh/discussions
***************************************************************************/

/*
 *                                                                         *
 *   This software is released under the MIT License.                      *
 *   See the LICENSE file for full details.                                 *
 *                                                                         *
 ***************************************************************************/

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