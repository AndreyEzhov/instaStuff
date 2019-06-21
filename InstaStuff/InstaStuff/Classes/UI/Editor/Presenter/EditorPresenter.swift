//
//  EditorPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol EditorDisplayable: View {
    func updateContent(old: [EditModule], new: [EditModule])
}

/// Интерфейс презентера
protocol EditorPresentable: Presenter, EditorToolbarProtocol {
    var editorToolbarDelegate: EditorToolbarProtocol? { set get }
    var modules: [EditModule] { get }
    func update(with modules: [EditModule])
}

/// Презентер для экрана «Editor»
final class EditorPresenter: EditorPresentable {
    
    // MARK: - Nested types
    
    typealias T = EditorDisplayable
    
    private(set) var modules: [EditModule] = []
    
    weak var editorToolbarDelegate: EditorToolbarProtocol?
    
    /// Параметры экрана
    struct Parameters {
    
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(params: Parameters) {
        
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - EditorPresentable
    
    func update(with modules: [EditModule]) {
        contentView()?.updateContent(old: self.modules, new: modules)
        self.modules = modules
    }
    
    @objc func collapseTouch() {
        editorToolbarDelegate?.collapseTouch()
    }
    
    @objc func doneTouch() {
        editorToolbarDelegate?.doneTouch()
    }

}
