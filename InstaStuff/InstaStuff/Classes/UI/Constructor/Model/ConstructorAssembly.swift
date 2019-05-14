//
//  ConstructorAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 14/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «Constructor»
protocol ConstructorAssembly {
    
    /// Экран «Constructor»
    ///
    /// - Returns: View Controller
    func createConstructorController(params: ConstructorPresenter.Parameters) -> UIViewController
    
}

extension Assembly: ConstructorAssembly {
    
    /// Экран «Constructor»
    ///
    /// - Returns: View Controller
    func createConstructorController(params: ConstructorPresenter.Parameters) -> UIViewController {
        let presenter = ConstructorPresenter(params: params)
        return ConstructorController.controller(presenter: presenter)
    }
    
}
