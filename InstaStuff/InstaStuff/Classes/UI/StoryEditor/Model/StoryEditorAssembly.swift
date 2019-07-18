//
//  StoryEditorAssembly.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol StoryEditorAssembly {
    
    func createStoryEditorController(parameters: StoryEditorPresenter.Parameters) -> UIViewController
    
}

extension Assembly: StoryEditorAssembly {
    
    func createStoryEditorController(parameters: StoryEditorPresenter.Parameters) -> UIViewController {
        let presenter = StoryEditorPresenter(dependencies: StoryEditorPresenter.Dependencies(templatesStorage: templatesStorage, imageHandler: imageHandler), parameters: parameters)
        return StoryEditorController.controller(presenter: presenter)
    }
    
}
