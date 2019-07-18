//
//  UsersCollectionRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «UsersCollection»
protocol UsersCollectionRouter {
    
    /// Перейти на экран «UsersCollection»
    func routeToUsersCollection(params: UsersCollectionPresenter.Parameters)
    
}

extension Router: UsersCollectionRouter {
    
    func routeToUsersCollection(params: UsersCollectionPresenter.Parameters) {
        let controller = Assembly.shared.createUsersCollectionController(params: params)
        navigate(to: controller)
    }
    
}
