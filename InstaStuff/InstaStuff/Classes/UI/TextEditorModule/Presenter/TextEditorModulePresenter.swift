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
    var editableItems: [TextEdibaleItemModel] { get }
    var view: TextEditorModuleDisplayable? { get set }
    var textSetups: TextSetupsEditable? { get set }
    var selectedIndexes: [Int] { get }
    func select(at index: Int)
}

/// Презентер для экрана «TextEditorModule»
final class TextEditorModulePresenter: TextEditorModulePresentable {
    
    // MARK: - Nested types
    
    let editableItems: [TextEdibaleItemModel]
    
    var selectedIndexes: [Int] = []
    
    weak var view: TextEditorModuleDisplayable?
    
    var textSetups: TextSetupsEditable? {
        didSet {
            
        }
    }
    
    /// Параметры экрана
    struct Parameters {
        
    }
    
    // MARK: - Construction
    
    init(params: Parameters) {
        editableItems = [
            TextEdibaleItemModel(item: .bold),
            TextEdibaleItemModel(item: .italic)
        ]
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - TextEditorModulePresentable
    
    func select(at index: Int) {
        let model = editableItems[index]
    }
    
}
