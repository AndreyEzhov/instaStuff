//
//  BackgroundImageEditModuleAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «BackgroundImageEditModule»
protocol BackgroundImageEditModuleAssembly {
    
    /// Экран «BackgroundImageEditModule»
    ///
    /// - Returns: View Controller
    func createBackgroundImageEditModuleController(params: BackgroundImageEditModulePresenter.Parameters) -> BackgroundImageEditModuleController
    
}

extension Assembly: BackgroundImageEditModuleAssembly {
    
    /// Экран «BackgroundImageEditModule»
    ///
    /// - Returns: View Controller
    func createBackgroundImageEditModuleController(params: BackgroundImageEditModulePresenter.Parameters) -> BackgroundImageEditModuleController {
        let presenter = BackgroundImageEditModulePresenter(params: params)
        return BackgroundImageEditModuleController.controller(presenter: presenter) as! BackgroundImageEditModuleController
    }
    
}
