//
//  UsersCollectionAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 14/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «UsersCollection»
protocol UsersCollectionAssembly {
    
    /// Экран «UsersCollection»
    ///
    /// - Returns: View Controller
    func createUsersCollectionController(params: UsersCollectionPresenter.Parameters) -> UsersCollectionController
    
}

extension Assembly: UsersCollectionAssembly {
    
    /// Экран «UsersCollection»
    ///
    /// - Returns: View Controller
    func createUsersCollectionController(params: UsersCollectionPresenter.Parameters) -> UsersCollectionController {
        let presenter = UsersCollectionPresenter(dependencies: UsersCollectionPresenter.Dependencies(templatesStorage: templatesStorage), params: params)
        return UsersCollectionController.controller(presenter: presenter)
    }
    
}
