//
//  TextEditorModuleAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «TextEditorModule»
protocol TextEditorModuleAssembly {
    
    /// Экран «TextEditorModule»
    ///
    /// - Returns: View Controller
    func createTextEditorModuleController(params: TextEditorModulePresenter.Parameters) -> TextEditorModuleController
    
}

extension Assembly: TextEditorModuleAssembly {
    
    /// Экран «TextEditorModule»
    ///
    /// - Returns: View Controller
    func createTextEditorModuleController(params: TextEditorModulePresenter.Parameters) -> TextEditorModuleController {
        let presenter = TextEditorModulePresenter(params: params)
        return TextEditorModuleController.controller(presenter: presenter)
    }
    
}
