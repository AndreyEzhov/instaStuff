//
//  ColorCell.swift
//  InstaStuff
//
//  Created by aezhov on 20/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    // MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Func
    
    private func setup() {
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = contentView.layer.bounds.width / 2.0
    }
    
    // MARK: - Functions
    
    func setup(with color: ColorEnum) {
        contentView.backgroundColor = color.color
    }
    
}
