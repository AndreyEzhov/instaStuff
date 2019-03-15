//
//  TemplatePickerRouter.swift
//  SocialTrading
//
//  Created by akonshin on 02/12/2018.
//  Copyright © 2018 com.exness. All rights reserved.
//

import UIKit

/// Протокол роутера для экрана «TemplatePicker»
protocol TemplatePickerRouter {
    
    /// Перейти на экран «TemplatePicker»
    func routeToTemplatePicker(params: TemplatePickerPresenter.Parameters)
    
}

extension Router: TemplatePickerRouter {
    
    func routeToTemplatePicker(params: TemplatePickerPresenter.Parameters) {
        let controller = Assembly.shared.createTemplatePickerController(params: params)
        navigate(to: controller)
    }
    
}
