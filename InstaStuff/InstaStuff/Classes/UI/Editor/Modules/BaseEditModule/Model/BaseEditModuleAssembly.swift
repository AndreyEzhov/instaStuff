//
//  BaseEditModuleAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 19/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «BaseEditModule»
protocol BaseEditModuleAssembly {
    
    /// Экран «BaseEditModule»
    ///
    /// - Returns: View Controller
    func createBaseEditModuleController(params: BaseEditModulePresenter.Parameters) -> BaseEditModuleController
    
}

extension Assembly: BaseEditModuleAssembly {
    
    /// Экран «SliderEditModule»
    ///
    /// - Returns: View Controller
    func createBaseEditModuleController(params: BaseEditModulePresenter.Parameters) -> BaseEditModuleController {
        let presenter = BaseEditModulePresenter(params: params)
        return BaseEditModuleController.controller(presenter: presenter)
    }
    
}
