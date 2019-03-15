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
        let presenter = MainScreenPresenter(dependencies: MainScreenPresenter.Dependencies(storyStorage: storyStorage))
        return MainScreenController.controller(presenter: presenter)
    }
    
}
