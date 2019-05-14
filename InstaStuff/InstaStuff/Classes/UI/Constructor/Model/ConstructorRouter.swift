//
//  ConstructorRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «Constructor»
protocol ConstructorRouter {
    
    /// Перейти на экран «Constructor»
    func routeToConstructor(params: ConstructorPresenter.Parameters)
    
}

extension Router: ConstructorRouter {
    
    func routeToConstructor(params: ConstructorPresenter.Parameters) {
        let controller = Assembly.shared.createConstructorController(params: params)
        navigate(to: controller)
    }
    
}
