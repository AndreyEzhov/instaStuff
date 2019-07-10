//
//  FrameEditModulePresenter.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

final class FrameEditModulePresenter: ItemEditModulePresentable {
    
    // MARK: - Nested types
    
    typealias T = ItemEditModuleDisplayable
    
    private let templatesStorage: TemplatesStorage
    
    weak var slideViewPresenter: SlideViewPresenter?
    
    let numberOfRows: Int
    
    private let photoItems: [PhotoPlaceConstructorSettings]
    
    var dataSource: [PreviewProtocol] {
        return photoItems
    }
    
    /// Параметры экрана
    struct Parameters {
        let numberOfRows: Int
    }
    
    // MARK: - Properties
    
    weak var view: View?
    
    // MARK: - Construction
    
    init(params: Parameters, templatesStorage: TemplatesStorage) {
        self.templatesStorage = templatesStorage
        numberOfRows = params.numberOfRows
        photoItems = []
//        let photoItem = PhotoItem(frameName: "frame1_1", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 200.0 / 517.0), sizeWidth: 340.0 / 397.0, angle: 0, ratio: 340.0 / 336.0))
//        
//        photoItems = [
//            PhotoPlaceConstructorSettings(photoItem: photoItem,
//                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 397.0/517.0))
//        ]
        
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - ItemEditModulePresentable
    
    func select(at index: Int) {
//        guard let photoPlaceConstructor = slideView?.editableView as? PhotoPlaceConstructor else { return }
//        let photoItem = photoItems[index]
//        photoPlaceConstructor.modify(with: photoItem)
//        slideView?.updateEditableView()
    }
    
}
