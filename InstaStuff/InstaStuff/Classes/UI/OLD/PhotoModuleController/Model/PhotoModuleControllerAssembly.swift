//
//  PhotoModuleControllerAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «PhotoModuleController»
protocol PhotoModuleControllerAssembly {
    
    /// Экран «PhotoModuleController»
    ///
    /// - Returns: View Controller
    func createPhotoModuleControllerController(params: PhotoModuleControllerPresenter.Parameters) -> PhotoModuleControllerController
    
}

extension Assembly: PhotoModuleControllerAssembly {
    
    /// Экран «PhotoModuleController»
    ///
    /// - Returns: View Controller
    func createPhotoModuleControllerController(params: PhotoModuleControllerPresenter.Parameters) -> PhotoModuleControllerController {
        let presenter = PhotoModuleControllerPresenter(params: params)
        return PhotoModuleControllerController.controller(presenter: presenter)
    }
    
}
