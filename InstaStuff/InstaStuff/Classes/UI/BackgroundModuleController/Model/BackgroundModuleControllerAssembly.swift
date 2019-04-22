//
//  BackgroundModuleControllerAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «BackgroundModuleController»
protocol BackgroundModuleControllerAssembly {
    
    /// Экран «BackgroundModuleController»
    ///
    /// - Returns: View Controller
    func createBackgroundModuleControllerController(params: BackgroundModuleControllerPresenter.Parameters) -> BackgroundModuleControllerController
    
}

extension Assembly: BackgroundModuleControllerAssembly {
    
    /// Экран «BackgroundModuleController»
    ///
    /// - Returns: View Controller
    func createBackgroundModuleControllerController(params: BackgroundModuleControllerPresenter.Parameters) -> BackgroundModuleControllerController {
        let presenter = BackgroundModuleControllerPresenter(params: params)
        return BackgroundModuleControllerController.controller(presenter: presenter)
    }
    
}
