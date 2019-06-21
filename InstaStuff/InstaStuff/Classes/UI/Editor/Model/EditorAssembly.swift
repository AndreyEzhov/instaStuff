//
//  EditorAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «Editor»
protocol EditorAssembly {
    
    /// Экран «Editor»
    ///
    /// - Returns: View Controller
    func createEditorController(params: EditorPresenter.Parameters) -> EditorController
    
}

extension Assembly: EditorAssembly {
    
    /// Экран «Editor»
    ///
    /// - Returns: View Controller
    func createEditorController(params: EditorPresenter.Parameters) -> EditorController {
        let presenter = EditorPresenter(params: params)
        return EditorController.controller(presenter: presenter) as! EditorController
    }
    
}
