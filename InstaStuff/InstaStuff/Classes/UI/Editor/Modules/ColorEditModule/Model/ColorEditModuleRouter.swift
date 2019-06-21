//
//  ColorEditModuleRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «ColorEditModule»
protocol ColorEditModuleRouter {
    
    /// Перейти на экран «ColorEditModule»
    func routeToColorEditModule(params: ColorEditModulePresenter.Parameters)
    
}

extension Router: ColorEditModuleRouter {
    
    func routeToColorEditModule(params: ColorEditModulePresenter.Parameters) {
        let controller = Assembly.shared.createColorEditModuleController(params: params)
        navigate(to: controller)
    }
    
}
