//
//  MenuEditModuleAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 19/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «MenuEditModule»
protocol MenuEditModuleAssembly {
    
    /// Экран «MenuEditModule»
    ///
    /// - Returns: View Controller
    func createMenuEditModuleController(params: MenuEditModulePresenter.Parameters) -> MenuEditModuleController
    
}

extension Assembly: MenuEditModuleAssembly {
    
    /// Экран «SliderEditModule»
    ///
    /// - Returns: View Controller
    func createMenuEditModuleController(params: MenuEditModulePresenter.Parameters) -> MenuEditModuleController {
        let presenter = MenuEditModulePresenter(params: params)
        return MenuEditModuleController.controller(presenter: presenter) as! MenuEditModuleController
    }
    
}
