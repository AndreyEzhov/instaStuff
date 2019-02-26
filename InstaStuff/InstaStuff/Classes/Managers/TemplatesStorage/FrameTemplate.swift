//
//  FrameTemplate.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

struct FrameTemplate {
    
    typealias TemplateId = Int
    
    // MARK: - Properties
    
    let id: TemplateId
    
    let name: String
    
    let photoAreas: [UIBezierPath]
    
}
