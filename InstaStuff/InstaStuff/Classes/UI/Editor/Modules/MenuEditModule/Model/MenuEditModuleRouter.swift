//
//  MenuEditModuleRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «MenuEditModule»
protocol MenuEditModuleRouter {
    
    /// Перейти на экран «MenuEditModule»
    func routeToMenuEditModule(params: MenuEditModulePresenter.Parameters)
    
}

extension Router: MenuEditModuleRouter {
    
    func routeToMenuEditModule(params: MenuEditModulePresenter.Parameters) {
        let controller = Assembly.shared.createMenuEditModuleController(params: params)
        navigate(to: controller)
    }
    
}
