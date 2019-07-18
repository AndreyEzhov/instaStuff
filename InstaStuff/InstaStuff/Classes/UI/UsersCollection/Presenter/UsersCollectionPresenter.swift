//
//  UsersCollectionPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 14/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import Foundation

/// Протокол для общения с вью частью
protocol UsersCollectionDisplayable: View {

}

/// Интерфейс презентера
protocol UsersCollectionPresentable: Presenter {

}

/// Презентер для экрана «UsersCollection»
final class UsersCollectionPresenter: UsersCollectionPresentable {
    
    // MARK: - Nested types
    
    struct Dependencies {
        let templatesStorage: TemplatesStorage
    }
    
    typealias T = UsersCollectionDisplayable
    
    /// Параметры экрана
    struct Parameters {
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    let templatesStorage: TemplatesStorage
    
    // MARK: - Construction
    
    init(dependencies: Dependencies, params: Parameters) {
        templatesStorage = dependencies.templatesStorage
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - UsersCollectionPresentable

}
