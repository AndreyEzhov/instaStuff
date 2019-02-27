//
//  TemplatesStorage.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class TemplatesStorage {
    
    // MARK: - Properties
    
    private(set) var templateSets: [TemplateSet]
    
    // MARK: - Consruction
    
    init() {
        templateSets = [
            TemplateSet(id: 1, name: "Set 1", templates: []),
            TemplateSet(id: 2, name: "Set 2", templates: []),
            TemplateSet(id: 3, name: "Set 3", templates: []),
            TemplateSet(id: 2, name: "Set 4", templates: []),
            TemplateSet(id: 3, name: "Set 5", templates: []),
            TemplateSet(id: 2, name: "Set 6", templates: []),
            TemplateSet(id: 3, name: "Set 7", templates: []),
            TemplateSet(id: 2, name: "Set 8", templates: []),
            TemplateSet(id: 3, name: "Set 9", templates: [])
        ]
    }
    
}
