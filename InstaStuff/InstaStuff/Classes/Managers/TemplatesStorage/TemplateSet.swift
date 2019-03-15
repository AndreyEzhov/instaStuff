//
//  TemplateSet.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

struct TemplateSet {
    
    typealias TemplateSetId = Int
    
    // MARK: - Properties
    
    let id: TemplateSetId
    
    let themeColor: UIColor
    
    let name: String
    
    let templates: [FrameTemplate]
    
}
