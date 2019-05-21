//
//  EditViewPeresenter.swift
//  InstaStuff
//
//  Created by aezhov on 20/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol EditViewPeresenterDelegate: class {
    func setupPhotoEditMenu(hidden: Bool, animated: Bool)
}

class EditViewPeresenter {
    
    weak var delegate: EditViewPeresenterDelegate?
    
    private(set) var isEditing: Bool = false
    
    weak var slideView: ConstructorSlideView?
    
    // MARK: - Functions
    
    func beginEdit() {
        isEditing = true
        delegate?.setupPhotoEditMenu(hidden: false, animated: true)
    }
    
    func endEditing() {
        isEditing = false
        delegate?.setupPhotoEditMenu(hidden: true, animated: true)
    }
    
    func modify(with photoItem: PhotoPlaceConstructorSettings) {
        guard let photoPlaceConstructor = slideView?.editableView as? PhotoPlaceConstructor else { return }
        photoPlaceConstructor.modify(with: photoItem)
        slideView?.updateEditableView()
    }

}
