//
//  ConstructorSlideView.swift
//  InstaStuff
//
//  Created by aezhov on 14/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class ConstructorSlideView: UIView {
    
    // MARK: - Properties
    
    private var items: [UIViewTemplatePlaceble] = []

    // MARK: - Construction
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        clipsToBounds = true
    }
    
    // MARK: - Functions
    
    func add(_ placebleView: UIViewTemplatePlaceble) {
        addSubview(placebleView)
        items.append(placebleView)
        let settings = placebleView.storyEditableItem.settings
        placebleView.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2.0)
            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2.0)
            maker.width.equalToSuperview().multipliedBy(settings.sizeWidth)
            maker.width.equalTo(placebleView.snp.height).multipliedBy(settings.ratio)
        }
    }

}
