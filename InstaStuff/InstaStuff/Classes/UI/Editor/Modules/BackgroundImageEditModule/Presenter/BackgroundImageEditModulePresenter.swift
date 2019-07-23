//
//  BackgroundImageEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol BackgroundImageEditModuleDisplayable: View {

}

/// Интерфейс презентера
protocol BackgroundImageEditModulePresentable: Presenter {
    var delegate: BackgroundImagePickerListener? { get }
}

/// Презентер для экрана «BackgroundImageEditModule»
final class BackgroundImageEditModulePresenter: BackgroundImageEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = BackgroundImageEditModuleDisplayable
    
    /// Параметры экрана
    struct Parameters {
        let delegate: BackgroundImagePickerListener
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    weak var delegate: BackgroundImagePickerListener?
    
    // MARK: - Construction
    
    init(params: Parameters) {
        delegate = params.delegate
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - BackgroundImageEditModulePresentable

}
