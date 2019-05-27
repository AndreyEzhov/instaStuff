//
//  ConstructorPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 14/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol ConstructorDisplayable: View {

}

/// Интерфейс презентера
protocol ConstructorPresentable: Presenter {
    var editViewPeresenter: EditViewPresenter { get }
    var stuffItemsPresenter: StuffItemsPresenter { get }
}

/// Презентер для экрана «Constructor»
final class ConstructorPresenter: ConstructorPresentable {
    
    // MARK: - Nested types
    
    typealias T = ConstructorDisplayable
    
    /// Параметры экрана
    struct Parameters {
    
    }
    
    private let templatesStorage: TemplatesStorage
    
    let editViewPeresenter = EditViewPresenter()
    
    let stuffItemsPresenter: StuffItemsPresenter
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(params: Parameters, templatesStorage: TemplatesStorage) {
        self.templatesStorage = templatesStorage
        stuffItemsPresenter = StuffItemsPresenter(templatesStorage: templatesStorage)
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - ConstructorPresentable

}
