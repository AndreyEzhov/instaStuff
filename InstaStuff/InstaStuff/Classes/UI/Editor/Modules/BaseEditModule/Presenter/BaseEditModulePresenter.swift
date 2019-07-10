//
//  BaseEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 19/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

@objc protocol BaseEditProtocol {
    @objc func moveToFront()
    @objc func moveToBack()
}

/// Протокол для общения с вью частью
protocol BaseEditModuleDisplayable: View {
}

/// Интерфейс презентера
protocol BaseEditModulePresentable: Presenter {
    var baseEditHandler: BaseEditProtocol { get }
}

/// Презентер для экрана «SliderEditModule»
final class BaseEditModulePresenter: BaseEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = BaseEditModuleDisplayable
    
    /// Параметры экрана
    struct Parameters {
        let baseEditHandler: BaseEditProtocol
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    let baseEditHandler: BaseEditProtocol
    
    // MARK: - Construction
    
    init(params: Parameters) {
        baseEditHandler = params.baseEditHandler
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - BaseEditModulePresentable

}
