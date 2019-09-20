//
//  EditorPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import UIKit

/// Протокол для общения с вью частью
protocol EditorDisplayable: View {
    var editorToolbar: EditorToolbar { get }
    func updateContent(old: [EditModule], new: [EditModule])
}

/// Интерфейс презентера
protocol EditorPresentable: Presenter, EditorToolbarProtocol {
    var contentSize: CGSize { get }
    func update(with state: EditorPresenter.State)
    func defaultState()
}

/// Презентер для экрана «Editor»
final class EditorPresenter: EditorPresentable {
    
    // MARK: - Nested types
    
    enum State {
        case main(MenuViewProtocol?), addStuff(SlideViewPresenter), stuffEdit(BaseEditProtocol), backgroundChange(BackgroundPickerListener), addPhotoFrame(BaseEditProtocol)
    }
    
    typealias T = EditorDisplayable
    
    private(set) var modules: [EditModule] = []
    
    /// Параметры экрана
    struct Parameters {
        let delegate: EditorDisplayer
        let menuViewProtocol: MenuViewProtocol
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    private weak var editorDisplayer: EditorDisplayer?
    
    private weak var menuViewProtocol: MenuViewProtocol?
    
    init(params: Parameters) {
        editorDisplayer = params.delegate
        menuViewProtocol = params.menuViewProtocol
    }
    
    var contentSize: CGSize {
        if isCollapsed {
            return CGSize(width: UIScreen.main.bounds.width,
                          height: EditorController.Constants.toolbarHeight)
        }
        let modulesHeight = modules.reduce(CGFloat.zero) { (res, model) -> CGFloat in
            return res + model.height
        }
        return CGSize(width: UIScreen.main.bounds.width,
                      height: EditorController.Constants.toolbarHeight + modulesHeight)
    }
    
    private var isCollapsed = false {
        didSet {
            contentView()?.editorToolbar.isCollapsed = isCollapsed
        }
    }
    
    weak var slideViewPresenter: SlideViewPresenter?
    
    // MARK: - Private Functions
    
    private func mainState(_ menuViewDelegate: MenuViewProtocol?) -> [EditModule] {
        guard let menuViewDelegate = menuViewDelegate else { return [] }
        self.menuViewProtocol = menuViewDelegate
        let controller = Assembly.shared.createMenuEditModuleController(params: MenuEditModulePresenter.Parameters())
        controller.setupActions(for: menuViewDelegate)
        return [EditModule(estimatedHeight: 92, controller: controller)]
    }
    
    private func addStuff(_ slideViewPresenter: SlideViewPresenter) -> [EditModule] {
        let controller = Assembly.shared.createItemEditModuleController(params: ItemEditModulePresenter.Parameters(numberOfRows: 2))
        let module = EditModule(estimatedHeight: 120, controller: controller)
        controller.presenter.slideViewPresenter = slideViewPresenter
        return [module]
    }
    
    private func stuffEdit(_ baseEditHandler: BaseEditProtocol) -> [EditModule] {
        let сontroller = Assembly.shared.createBaseEditModuleController(params: BaseEditModulePresenter.Parameters(showLock: false, baseEditHandler: baseEditHandler))
        let module = EditModule(estimatedHeight: 60, controller: сontroller)
        return [module]
    }
    
    private func backgroundEdit(delegate: BackgroundPickerListener) -> [EditModule] {
        let colorController = Assembly.shared.createColorEditModuleController(params: ColorEditModulePresenter.Parameters.init(delegate: delegate))
        let colorModule = EditModule(estimatedHeight: 60, controller: colorController)
        
        let imageController = Assembly.shared.createBackgroundImageEditModuleController(params: BackgroundImageEditModulePresenter.Parameters.init(delegate: delegate))
        let imageModule = EditModule(estimatedHeight: 80, controller: imageController)
        return [imageModule, colorModule]
    }
    
    private func addPhotoFrame(_ baseEditHandler: BaseEditProtocol) -> [EditModule] {
        let shapeController = Assembly.shared.createShapeEditModuleController(params: ShapeEditModulePresenter.Parameters(numberOfRows: 1))
        let shapeModule = EditModule(estimatedHeight: 60, controller: shapeController)
        shapeController.presenter.slideViewPresenter = slideViewPresenter
        let framesController = Assembly.shared.createFrameEditModuleController(params: FrameEditModulePresenter.Parameters(numberOfRows: 1))
        let frameModule = EditModule(estimatedHeight: 60, controller: framesController)
        framesController.presenter.slideViewPresenter = slideViewPresenter
        let baseController = Assembly.shared.createBaseEditModuleController(params: BaseEditModulePresenter.Parameters(showLock: true, baseEditHandler: baseEditHandler))
        let baseModule = EditModule(estimatedHeight: 60, controller: baseController)
        return [shapeModule, frameModule, baseModule]
    }
    
    // MARK: - Functions
    
    // MARK: - EditorPresentable
    
    func defaultState() {
        update(with: .main(menuViewProtocol))
    }
    
    func update(with state: EditorPresenter.State) {
        var newModules: [EditModule]
        var hideDoneButton = false
        switch state {
        case .main(let menuViewDelegate):
            hideDoneButton = true
            newModules = mainState(menuViewDelegate)
        case .addStuff(let slideViewPresenter):
            newModules = addStuff(slideViewPresenter)
        case .stuffEdit(let baseEditHandler):
            newModules = stuffEdit(baseEditHandler)
        case .backgroundChange(let colorPickerListener):
            newModules = backgroundEdit(delegate: colorPickerListener)
        case .addPhotoFrame(let baseEditHandler):
            newModules = addPhotoFrame(baseEditHandler)
        }
        contentView()?.editorToolbar.setDoneButton(hidden: hideDoneButton)
        contentView()?.updateContent(old: modules, new: newModules)
        modules = newModules
        editorDisplayer?.changeMenuSize(animated: true)
    }
    
    @objc func collapseTouch() {
        isCollapsed.toggle()
        editorDisplayer?.changeMenuSize(animated: true)
    }
    
    @objc func doneTouch() {
        defaultState()
        slideViewPresenter?.storySlideView.editableView.accept(nil)
    }
    
}
