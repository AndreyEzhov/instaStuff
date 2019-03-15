//
//  TemplatePickerPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 14/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol TemplatePickerDisplayable: View {

}

/// Интерфейс презентера
protocol TemplatePickerPresentable: Presenter {
    var templateSets: [TemplateSet] { get }
}

/// Презентер для экрана «TemplatePicker»
final class TemplatePickerPresenter: TemplatePickerPresentable {
    
    // MARK: - Nested types
    
    typealias T = TemplatePickerDisplayable
    
    /// Параметры экрана
    struct Parameters {
    
    }
    
    struct Dependencies {
        let templatesStorage: TemplatesStorage
    }
    
    let templatesStorage: TemplatesStorage
    
    var templateSets: [TemplateSet] {
        return templatesStorage.templateSets
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(params: Parameters, dependencies: Dependencies) {
        templatesStorage = dependencies.templatesStorage
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - TemplatePickerPresentable

}
