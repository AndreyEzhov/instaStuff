//
//  ColorCell.swift
//  InstaStuff
//
//  Created by aezhov on 20/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let imageView = UIImageView()
    
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
        contentView.addSubview(imageView)
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        imageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = contentView.layer.bounds.width / 2.0
    }
    
    // MARK: - Functions
    
    func setup(with color: ColorEnum) {
        updateTintColor(color)
        contentView.backgroundColor = color.color
        imageView.image = color.image?.withRenderingMode(.alwaysTemplate)
    }
    
    func updateTintColor(_ color: ColorEnum) {
        switch color {
        case .empty(let tintColor):
            imageView.tintColor = tintColor
        default:
            break
        }
    }
    
}
