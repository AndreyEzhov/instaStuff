//
//  FrameTemplate.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

struct FrameTemplate {
    
    typealias TemplateId = String
    
    // MARK: - Properties
    
    let id: TemplateId
    
    let name: String
    
    var backgroundColor: UIColor
    
    let frameAreas: [FrameAreaDescription]
    
    var backgroundImage: UIImage? {
        return UIImage(named: id + "_background")
    }
    
    var previewImage: UIImage? {
        return UIImage(named: id + "_preview")
    }
    
}
