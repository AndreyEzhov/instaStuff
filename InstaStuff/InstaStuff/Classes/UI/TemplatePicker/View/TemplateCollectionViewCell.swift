//
//  TemplateCollectionViewCell.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 27.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class TemplateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var previewImageView = UIImageView()
    
    override var isHighlighted: Bool {
        didSet { setTappedState(isHighlighted, animated: true) }
    }
    
    // MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        contentView.addSubview(previewImageView)
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        previewImageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    // MARK: - Function
    
    func setup(with previewImage: UIImage?) {
        previewImageView.image = previewImage
    }
    
}



