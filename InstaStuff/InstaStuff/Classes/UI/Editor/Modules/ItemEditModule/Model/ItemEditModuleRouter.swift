//
//  ItemEditModuleRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «ItemEditModule»
protocol ItemEditModuleRouter {
    
    /// Перейти на экран «ItemEditModule»
    func routeToItemEditModule(params: ItemEditModulePresenter.Parameters)
    
}

extension Router: ItemEditModuleRouter {
    
    func routeToItemEditModule(params: ItemEditModulePresenter.Parameters) {
        let controller = Assembly.shared.createItemEditModuleController(params: params)
        navigate(to: controller)
    }
    
}
