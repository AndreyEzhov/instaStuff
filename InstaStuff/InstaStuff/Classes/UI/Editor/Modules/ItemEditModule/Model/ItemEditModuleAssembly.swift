//
//  ItemEditModuleAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «ItemEditModule»
protocol ItemEditModuleAssembly {
    
    /// Экран «ItemEditModule»
    ///
    /// - Returns: View Controller
    func createItemEditModuleController(params: ItemEditModulePresenter.Parameters) -> ItemEditModuleController
    
    func createShapeEditModuleController(params: ShapeEditModulePresenter.Parameters) -> ItemEditModuleController
    
    func createFrameEditModuleController(params: FrameEditModulePresenter.Parameters) -> ItemEditModuleController
    
    
}

extension Assembly: ItemEditModuleAssembly {
    
    /// Экран «ItemEditModule»
    ///
    /// - Returns: View Controller
    func createItemEditModuleController(params: ItemEditModulePresenter.Parameters) -> ItemEditModuleController {
        let presenter = ItemEditModulePresenter(params: params, templatesStorage: templatesStorage)
        return ItemEditModuleController.controller(presenter: presenter) as! ItemEditModuleController
    }
    
    func createShapeEditModuleController(params: ShapeEditModulePresenter.Parameters) -> ItemEditModuleController {
        let presenter = ShapeEditModulePresenter(params: params)
        return ItemEditModuleController.controller(presenter: presenter) as! ItemEditModuleController
    }
    
    func createFrameEditModuleController(params: FrameEditModulePresenter.Parameters) -> ItemEditModuleController {
        let presenter = FrameEditModulePresenter(params: params, templatesStorage: templatesStorage)
        return ItemEditModuleController.controller(presenter: presenter) as! ItemEditModuleController
    }
    
}
