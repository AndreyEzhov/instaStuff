//
//  BaseEditModuleRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «BaseEditModule»
protocol BaseEditModuleRouter {
    
    /// Перейти на экран «BaseEditModule»
    func routeToBaseEditModule(params: BaseEditModulePresenter.Parameters)
    
}

extension Router: BaseEditModuleRouter {
    
    func routeToBaseEditModule(params: BaseEditModulePresenter.Parameters) {
        let controller = Assembly.shared.createBaseEditModuleController(params: params)
        navigate(to: controller)
    }
    
}
