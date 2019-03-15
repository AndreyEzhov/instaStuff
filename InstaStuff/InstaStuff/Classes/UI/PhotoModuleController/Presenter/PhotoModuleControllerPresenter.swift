//
//  PhotoModuleControllerPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol PhotoModuleControllerDisplayable: class {

}

/// Интерфейс презентера
protocol PhotoModuleControllerPresentable: class {
    var view: PhotoModuleControllerDisplayable? { get set }
}

/// Презентер для экрана «PhotoModuleController»
final class PhotoModuleControllerPresenter: PhotoModuleControllerPresentable {
    
    // MARK: - Nested types
    
    weak var view: PhotoModuleControllerDisplayable?
    
    /// Параметры экрана
    struct Parameters {
    
    }
    
    // MARK: - Construction
    
    init(params: Parameters) {
        
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - PhotoModuleControllerPresentable

}
