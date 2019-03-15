//
//  TextEditorModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol TextEditorModuleDisplayable: class {
    
}

/// Интерфейс презентера
protocol TextEditorModulePresentable: class {
    var editableItems: [TextEditableItem] { get }
    var view: TextEditorModuleDisplayable? { get set }
}

/// Презентер для экрана «TextEditorModule»
final class TextEditorModulePresenter: TextEditorModulePresentable {
    
    // MARK: - Nested types
    
    let editableItems: [TextEditableItem]
    
    weak var view: TextEditorModuleDisplayable?
    
    /// Параметры экрана
    struct Parameters {
        
    }
    
    // MARK: - Construction
    
    init(params: Parameters) {
        editableItems = TextEditableItem.defaultSet
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - TextEditorModulePresentable
    
}
