//
//  StoryPickerRouter.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol StoryPickerRouter {
    
    func routeToStoryPicker()
    
}

extension Router: StoryPickerRouter {
    
    func routeToStoryPicker() {
        let controller = Assembly.shared.createStoryPickerController()
        navigate(to: controller)
    }
    
}
