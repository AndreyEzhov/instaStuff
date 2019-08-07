//
//  SliderEditModuleAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 19/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «SliderEditModule»
protocol SliderEditModuleAssembly {
    
    /// Экран «SliderEditModule»
    ///
    /// - Returns: View Controller
    func createSliderEditModuleController(params: SliderEditModulePresenter.Parameters) -> SliderEditModuleController
    
}

extension Assembly: SliderEditModuleAssembly {
    
    /// Экран «SliderEditModule»
    ///
    /// - Returns: View Controller
    func createSliderEditModuleController(params: SliderEditModulePresenter.Parameters) -> SliderEditModuleController {
        let presenter = SliderEditModulePresenter(params: params)
        return SliderEditModuleController.controller(presenter: presenter)
    }
    
}
