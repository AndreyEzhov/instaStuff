//
//  StoryPickerAssembly.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol StoryPickerAssembly {
    
    func createStoryPickerController() -> UIViewController
    
}

extension Assembly: StoryPickerAssembly {
    
    func createStoryPickerController() -> UIViewController {
        let presenter = StoryPickerPresenter(dependencies: StoryPickerPresenter.Dependencies(storyStorage: storyStorage))
        return StoryPickerController.controller(presenter: presenter)
    }
    
}
