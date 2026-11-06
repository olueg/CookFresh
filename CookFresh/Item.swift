//
//  Item.swift
//  CookFresh
//
//  Created by Olaf Lueg on 06.11.26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
