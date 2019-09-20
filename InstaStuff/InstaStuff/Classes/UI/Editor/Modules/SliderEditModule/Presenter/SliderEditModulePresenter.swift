//
//  SliderEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 19/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import Foundation

protocol SliderListener: UIView {
    func valueDidChanged(_ value: Float)
}

/// Протокол для общения с вью частью
protocol SliderEditModuleDisplayable: View {

}

/// Интерфейс презентера
protocol SliderEditModulePresentable: Presenter {
    var value: Int { get set }
    var sliderListener: SliderListener? { get set }
}

/// Презентер для экрана «SliderEditModule»
final class SliderEditModulePresenter: SliderEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = SliderEditModuleDisplayable
    
    var value: Int {
        didSet {
            if value != oldValue {
                sliderListener?.valueDidChanged(Float(value) / 100.0)
            }
        }
    }
    
    weak var sliderListener: SliderListener?
    
    /// Параметры экрана
    struct Parameters {
        let value: Int
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(params: Parameters) {
        value = params.value
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - SliderEditModulePresentable

}
