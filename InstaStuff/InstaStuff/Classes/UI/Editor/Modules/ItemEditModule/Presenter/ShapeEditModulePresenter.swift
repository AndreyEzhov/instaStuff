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
    
    init(params: Parameters) {
        numberOfRows = params.numberOfRows
        photoItems = []
//        photoItems = [
//            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "square", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 1)),
//                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 1))
//            ,
//            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "1_to_2", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 2)),
//                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 2)),
//            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "2_to_1", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 0.5)),
//                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.4, angle: 0, ratio: 0.5)),
//            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "round", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 1)),
//                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 1)),
//            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "round_2", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 0.6)),
//                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.4, angle: 0, ratio: 0.6))
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
