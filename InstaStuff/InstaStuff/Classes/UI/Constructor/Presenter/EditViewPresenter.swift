//
//  EditViewPeresenter.swift
//  InstaStuff
//
//  Created by aezhov on 20/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol EditViewPeresenterDelegate: class {
    func setupPhotoEditMenu(hidden: Bool, animated: Bool, sender: CunstructorEditViewProtocol)
}

class EditViewPresenter: CunstructorEditViewProtocol {
    
    // MARK: - Properties
    
    weak var delegate: EditViewPeresenterDelegate?
    
    private(set) var isEditing: Bool = false
    
    weak var slideView: ConstructorSlideView?
    
    let photoItems: [PhotoPlaceConstructorSettings]
    
    var dataSource: [PreviewProtocol] {
        return photoItems
    }
    
    // MARK: - Construction
    
    init() {
        photoItems = [
            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "square", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 1)),
                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 1))
            ,
            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "1_to_2", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 2)),
                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 2)),
            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "2_to_1", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 0.5)),
                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.4, angle: 0, ratio: 0.5))
        ]
    }
    
    // MARK: - Functions
    
    func beginEdit() {
        isEditing = true
        delegate?.setupPhotoEditMenu(hidden: false, animated: true, sender: self)
    }
    
    func endEditing() {
        isEditing = false
        delegate?.setupPhotoEditMenu(hidden: true, animated: true, sender: self)
    }
    
    func select(at index: Int) {
        guard let photoPlaceConstructor = slideView?.editableView as? PhotoPlaceConstructor else { return }
        let photoItem = photoItems[index]
        photoPlaceConstructor.modify(with: photoItem)
        slideView?.updateEditableView()
    }

}
