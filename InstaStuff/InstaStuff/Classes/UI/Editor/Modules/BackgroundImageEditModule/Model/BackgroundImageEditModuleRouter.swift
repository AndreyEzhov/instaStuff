//
//  BackgroundImageEditModuleRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «ColorEditModule»
protocol BackgroundImageEditModuleRouter {
    
    /// Перейти на экран «ColorEditModule»
    func routeToBackgroundImageEditModule(params: BackgroundImageEditModulePresenter.Parameters)
    
}

extension Router: BackgroundImageEditModuleRouter {
    
    func routeToBackgroundImageEditModule(params: BackgroundImageEditModulePresenter.Parameters) {
        let controller = Assembly.shared.createBackgroundImageEditModuleController(params: params)
        navigate(to: controller)
    }
    
}
