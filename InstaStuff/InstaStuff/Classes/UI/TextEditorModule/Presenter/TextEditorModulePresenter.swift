//
//  TextEditorModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import UIKit

enum SliderEditionType {
    
    enum SliderType {
        case color, slider
    }
    
    case kern, lineSpacing, fontSize, color, backgroundColor
    
    var sliderType: SliderType {
        switch self {
        case .kern, .lineSpacing, .fontSize:
            return .slider
        default:
            return .color
        }
    }
}

struct SliderModel {
    let minValue: CGFloat
    let maxValue: CGFloat
    let value: CGFloat?
}

/// Протокол для общения с вью частью
protocol TextEditorModuleDisplayable: class {
    func updateView()
    func updateSlider(with model: SliderModel?)
    func updateColorPicker(with color: UIColor?)
}

/// Интерфейс презентера
protocol TextEditorModulePresentable: class {
    var baseEditor: BaseEditProtocol? { get set }
    var colorEditModuleController: ColorEditModuleController { get }
    var textSetups: TextSetups? { get set }
    var view: TextEditorModuleDisplayable? { get set }
    var fonts: [FontEnum] { get }
    var type: SliderEditionType { get }
    var pippeteDelegate: PippeteDelegate? { get set }
    func upperCase()
    func changeAlignment() -> Aligment
    func setFont(at index: Int)
    func setColor(_ color: UIColor)
    func beginEdition(with type: SliderEditionType)
    func valueDidChanged(_ value: Float)
    func moveToBack()
    func moveToFront()
}

/// Презентер для экрана «TextEditorModule»
final class TextEditorModulePresenter: TextEditorModulePresentable {

    // MARK: - Nested types
    
    weak var view: TextEditorModuleDisplayable?
    
    var textSetups: TextSetups? {
        didSet {
            view?.updateView()
            beginEdition(with: type)
        }
    }
    
    let fonts: [FontEnum] = FontEnum.allCases
    
    private(set) var type: SliderEditionType = .fontSize
    
    private(set) lazy var colorEditModuleController: ColorEditModuleController = {
        return Assembly.shared.createColorEditModuleController(params: ColorEditModulePresenter.Parameters(delegate: self))
    }()
    
    weak var pippeteDelegate: PippeteDelegate?
    
    weak var baseEditor: BaseEditProtocol?
    
    /// Параметры экрана
    struct Parameters {

    }
    
    // MARK: - Construction
    
    init(params: Parameters) {
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - TextEditorModulePresentable
    
    func upperCase() {
        textSetups?.upperCase()
    }
    
    func changeAlignment() -> Aligment {
        textSetups?.changeAlignment()
        return textSetups?.aligment ?? .left
    }
    
    func setFont(at index: Int) {
        textSetups?.update(with: fonts[index])
    }
    
    func setColor(_ color: UIColor) {
        if type == .backgroundColor {
            textSetups?.backgroundColor = color
        } else if type == .color {
            textSetups?.color = color
        }
    }
    
    func beginEdition(with type: SliderEditionType) {
        self.type = type
        var model: SliderModel?
        switch type {
        case .fontSize:
            model = SliderModel(minValue: 20, maxValue: 200, value: textSetups?.fontSize)
        case .kern:
            model = SliderModel(minValue: -8, maxValue: 60, value: textSetups?.kern)
        case .lineSpacing:
            model = SliderModel(minValue: -20, maxValue: 60, value: textSetups?.lineSpacing)
        case .color:
            view?.updateColorPicker(with: textSetups?.color)
        case .backgroundColor:
            view?.updateColorPicker(with: textSetups?.backgroundColor)
        }
        view?.updateSlider(with: model)
    }
    
    func valueDidChanged(_ value: Float) {
        switch type {
        case .fontSize:
            textSetups?.fontSize = CGFloat(value)
        case .kern:
            textSetups?.kern = CGFloat(value)
        case .lineSpacing:
            textSetups?.lineSpacing = CGFloat(value)
        case .color:
            break
        case .backgroundColor:
            break
        }
    }
    
    func moveToBack() {
        baseEditor?.moveToBack()
    }
    
    func moveToFront() {
        baseEditor?.moveToFront()
    }
    
}


extension TextEditorModulePresenter: ColorPickerListener {
    func colorDidChanged(_ value: UIColor) {
        if type == .backgroundColor {
            textSetups?.backgroundColor = value
        } else if type == .color {
            textSetups?.color = value
        }
    }
    
    var currentColor: UIColor? {
        if type == .backgroundColor {
            return textSetups?.backgroundColor
        } else if type == .color {
            return textSetups?.color
        } else {
            return nil
        }
    }
    
    func placePipette(completion: @escaping (UIColor?) -> ()) {
        pippeteDelegate?.placePipette(completion: completion)
    }
    
    
}
