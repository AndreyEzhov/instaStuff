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
    
    var backgroundImage: UIImage? {
        guard let imageName = backgroundImageName else {
            return nil
        }
        return UIImage(named: imageName)
    }
    
    var previewImage: UIImage? {
        return UIImage(named: name + "_preview")
    }
    
}


extension Template {
    init() {
        name = ""
        backgroundColor = .white
        backgroundImageName = nil
        storyEditableItem = []
    }
}
