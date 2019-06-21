//
//  SliderEditModuleRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «SliderEditModule»
protocol SliderEditModuleRouter {
    
    /// Перейти на экран «SliderEditModule»
    func routeToSliderEditModule(params: SliderEditModulePresenter.Parameters)
    
}

extension Router: SliderEditModuleRouter {
    
    func routeToSliderEditModule(params: SliderEditModulePresenter.Parameters) {
        let controller = Assembly.shared.createSliderEditModuleController(params: params)
        navigate(to: controller)
    }
    
}
