//
//  EditorRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «Editor»
protocol EditorRouter {
    
    /// Перейти на экран «Editor»
    func routeToEditor(params: EditorPresenter.Parameters)
    
}

extension Router: EditorRouter {
    
    func routeToEditor(params: EditorPresenter.Parameters) {
        let controller = Assembly.shared.createEditorController(params: params)
        navigate(to: controller)
    }
    
}
