//
//  BackgroundModuleControllerPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation
import UIKit

/// Протокол для общения с вью частью
protocol BackgroundModuleControllerDisplayable: class {

}

/// Интерфейс презентера
protocol BackgroundModuleControllerPresentable: class {
    var view: BackgroundModuleControllerDisplayable? { get set }
    var colors: [ColorEnum] { get }
}

/// Презентер для экрана «BackgroundModuleController»
final class BackgroundModuleControllerPresenter: BackgroundModuleControllerPresentable {
    
    // MARK: - Nested types
    
    weak var view: BackgroundModuleControllerDisplayable?
    
    /// Параметры экрана
    struct Parameters {

    }
    
    let colors: [ColorEnum] = ColorEnum.allCases
    
    // MARK: - Construction
    
    init(params: Parameters) {
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - BackgroundModuleControllerPresentable

}
