//
//  ColorEditModuleAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «ColorEditModule»
protocol ColorEditModuleAssembly {
    
    /// Экран «ColorEditModule»
    ///
    /// - Returns: View Controller
    func createColorEditModuleController(params: ColorEditModulePresenter.Parameters) -> ColorEditModuleController
    
}

extension Assembly: ColorEditModuleAssembly {
    
    /// Экран «ColorEditModule»
    ///
    /// - Returns: View Controller
    func createColorEditModuleController(params: ColorEditModulePresenter.Parameters) -> ColorEditModuleController {
        let presenter = ColorEditModulePresenter(params: params)
        return ColorEditModuleController.controller(presenter: presenter)
    }
    
}
