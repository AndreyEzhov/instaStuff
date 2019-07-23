//
//  FrameTemplate.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

struct Template {
    
    // MARK: - Properties
    
    let name: String
    
    let backgroundColor: UIColor
    
    let backgroundImageName: String?
    
    let storyEditableItem: [StoryEditableItem]
    
    let createdByUser: Bool
    
}


extension Template {
    
    init() {
        name = "\(Date())"
        backgroundColor = .white
        backgroundImageName = nil
        storyEditableItem = []
        createdByUser = true
    }
}

extension Template: Equatable {
    static func == (lhs: Template, rhs: Template) -> Bool {
        return lhs.name == rhs.name
    }
    
}
