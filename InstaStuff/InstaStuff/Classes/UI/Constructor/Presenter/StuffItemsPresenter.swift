//
//  StuffItemsPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 27/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StuffItemsPresenter: CunstructorEditViewProtocol {
    
    // MARK: - Properties
    
    private let templatesStorage: TemplatesStorage

    var dataSource: [PreviewProtocol] {
        return templatesStorage.stuffItems
    }
    
    weak var delegate: EditViewPeresenterDelegate?
    
    var slideView: ConstructorSlideView?
    
    // MARK: - Construction
    
    init(templatesStorage: TemplatesStorage) {
        self.templatesStorage = templatesStorage
    }
    // MARK: - Functions
    
    func beginEdit() {
        delegate?.setupPhotoEditMenu(hidden: false, animated: true, sender: self)
    }
    
    func endEditing() {
        delegate?.setupPhotoEditMenu(hidden: true, animated: true, sender: self)
    }
    
    func select(at index: Int) {
        let item = templatesStorage.stuffItems[index]
        let settings = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.2, angle: 0, ratio: item.stuffImage.size.width / item.stuffImage.size.height)
        slideView?.add(StuffPlace(StoryEditableStuffItem(item, settings: settings)))
    }
    
}
