/*
                       GeminiServiceModel.swift  -  description
                          -------------------
 begin                : Tue Nov 10 2026
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
//  GeminiServiceModel.swift
//  CookFresh
//
//  Created by Olaf Lueg on 10.11.26.
//

import SwiftUI
import SwiftData

@Model
class GeminiServiceModel{
    var id: UUID = UUID()
    var modelName: String = ""
    var modelDescription: String = ""
    var modelDisplayName: String = ""
    var selected: Bool = false
    var standard: Bool = false
    
    init(id: UUID, modelName: String, modelDescription: String, modelDisplayName: String, selected: Bool, standard: Bool) {
        self.id = id
        self.modelName = modelName
        self.modelDescription = modelDescription
        self.modelDisplayName = modelDisplayName
        self.selected = selected
        self.standard = standard
    }
}
