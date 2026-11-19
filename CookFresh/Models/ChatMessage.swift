/*
                       ChatMessage.swift  -  description
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
