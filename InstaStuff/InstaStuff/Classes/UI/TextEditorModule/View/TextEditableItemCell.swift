//
//  TextEditableItemCell.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class TextEditableItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            iconImageView.image = isSelected ? item.selectedImage : item.dafaultImage
        }
    }
    
    private var item: TextEditableItem!
    
    // MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        iconImageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        contentView.addSubview(iconImageView)
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Functions
    
    func setup(with item: TextEditableItem) {
        self.item = item
        isSelected = false
    }
    
}
