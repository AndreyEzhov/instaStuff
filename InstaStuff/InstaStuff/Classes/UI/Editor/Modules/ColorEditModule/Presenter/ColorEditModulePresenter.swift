//
//  ColorEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol ColorEditModuleDisplayable: View {

}

/// Интерфейс презентера
protocol ColorEditModulePresentable: Presenter {
    var delegate: ColorPickerListener? { get }
}

/// Презентер для экрана «ColorEditModule»
final class ColorEditModulePresenter: ColorEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = ColorEditModuleDisplayable
    
    /// Параметры экрана
    struct Parameters {
        let delegate: ColorPickerListener
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    weak var delegate: ColorPickerListener?
    
    // MARK: - Construction
    
    init(params: Parameters) {
        delegate = params.delegate
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - ColorEditModulePresentable

}
