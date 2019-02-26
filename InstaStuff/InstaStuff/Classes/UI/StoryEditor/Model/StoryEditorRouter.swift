//
//  StoryEditorRouter.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol StoryEditorRouter {
    
    func routeToStoryEditor(parameters: StoryEditorPresenter.Parameters)
    
}

extension Router: StoryEditorRouter {
    
    func routeToStoryEditor(parameters: StoryEditorPresenter.Parameters) {
        let controller = Assembly.shared.createStoryEditorController(parameters: parameters)
        navigate(to: controller)
    }
    
}
