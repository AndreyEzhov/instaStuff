//
//  EditViewPeresenter.swift
//  InstaStuff
//
//  Created by aezhov on 20/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol EditViewPeresenterDelegate: class {
    func setupColorEditMenu(hidden: Bool, animated: Bool, with modules: [EditModule])
}

struct PhotoPlaceConstructorSettings: PreviewProtocol {
    let photoItem: PhotoItem
    let settings: Settings
    var preview: UIImage? {
        return photoItem.preview
    }
}

protocol CunstructorEditViewProtocol {
    func beginEdit()
    func endEditing()
}

class EditViewPresenter: CunstructorEditViewProtocol {
    
    // MARK: - Properties
    
    weak var delegate: EditViewPeresenterDelegate?
    
    private(set) var isEditing: Bool = false
    
    weak var slideView: ConstructorSlideView? {
        didSet {
            shapeEditModuleController.presenter.slideView = slideView
            frameEditModuleController.presenter.slideView = slideView
        }
    }
    
    weak var sliderListener: SliderListener? {
        didSet {
            sliderEditModuleController.presenter.sliderListener = sliderListener
        }
    }
    
    private let modules: [EditModule]
    
    private let shapeEditModuleController: ItemEditModuleController
    
    private let frameEditModuleController: ItemEditModuleController
    
    private let sliderEditModuleController: SliderEditModuleController
    
    // MARK: - Construction
    
    init() {
        shapeEditModuleController = Assembly.shared.createShapeEditModuleController(params: ShapeEditModulePresenter.Parameters(numberOfRows: 1))
        let moduleShape = EditModule(estimatedHeight: 60, controller: shapeEditModuleController)
        frameEditModuleController = Assembly.shared.createFrameEditModuleController(params: FrameEditModulePresenter.Parameters(numberOfRows: 1))
        let moduleFrame = EditModule(estimatedHeight: 60, controller: frameEditModuleController)
        sliderEditModuleController = Assembly.shared.createSliderEditModuleController(params: SliderEditModulePresenter.Parameters(value: 0))
        let moduleSlider = EditModule(estimatedHeight: 40, controller: sliderEditModuleController)
        modules = [moduleShape, moduleFrame, moduleSlider]
    }
    
    // MARK: - Functions
    
    func beginEdit() {
        isEditing = true
        delegate?.setupColorEditMenu(hidden: false, animated: true, with: modules)
    }
    
    func endEditing() {
        isEditing = false
        delegate?.setupColorEditMenu(hidden: true, animated: true, with: [])
    }
    
}

extension EditViewPresenter: EditorToolbarProtocol {
    
    @objc func collapseTouch() {
        endEditing()
    }
    
    @objc func doneTouch() {
        endEditing()
    }
    
}
