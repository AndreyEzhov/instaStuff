//
//  ShapeEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

final class ShapeEditModulePresenter: ItemEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = ItemEditModuleDisplayable
    
    weak var slideViewPresenter: SlideViewPresenter?
    
    private let templatesStorage: TemplatesStorage
    
    let numberOfRows: Int
    
    var dataSource: [PreviewProtocol] {
        return templatesStorage.photoItemsShape
    }
    
    /// Параметры экрана
    struct Parameters {
        let numberOfRows: Int
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(params: Parameters, templatesStorage: TemplatesStorage) {
        numberOfRows = params.numberOfRows
        self.templatesStorage = templatesStorage
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - ItemEditModulePresentable
    
    func select(at index: Int) {
        let photoItem = templatesStorage.photoItemsShape[index]
        slideViewPresenter?.addOrModify(photoItem)
    }
    
}
