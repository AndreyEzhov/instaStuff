//
//  TemplatePickerAssembly.swift
//  InstaStuff
//
//  Created by aezhov on 14/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Сборщик экрана «TemplatePicker»
protocol TemplatePickerAssembly {
    
    /// Экран «TemplatePicker»
    ///
    /// - Returns: View Controller
    func createTemplatePickerController(params: TemplatePickerPresenter.Parameters) -> UIViewController
    
}

extension Assembly: TemplatePickerAssembly {
    
    /// Экран «TemplatePicker»
    ///
    /// - Returns: View Controller
    func createTemplatePickerController(params: TemplatePickerPresenter.Parameters) -> UIViewController {
        let presenter = TemplatePickerPresenter(params: params, dependencies: TemplatePickerPresenter.Dependencies.init(templatesStorage: templatesStorage))
        return TemplatePickerController.controller(presenter: presenter)
    }
    
}
