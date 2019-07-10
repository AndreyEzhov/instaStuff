//
//  MenuEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 19/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol MenuEditModuleDisplayable: View {

}

/// Интерфейс презентера
protocol MenuEditModulePresentable: Presenter {

}

/// Презентер для экрана «SliderEditModule»
final class MenuEditModulePresenter: MenuEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = MenuEditModuleDisplayable
    
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
    
    // MARK: - MenuEditModulePresentable

}
