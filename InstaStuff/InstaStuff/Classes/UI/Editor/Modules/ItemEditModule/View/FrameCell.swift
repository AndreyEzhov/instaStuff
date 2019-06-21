//
//  FrameCell.swift
//  InstaStuff
//
//  Created by aezhov on 21/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class FrameCell: UICollectionViewCell {
    
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
    
    // MARK: - Private Functions
    
    private func setup() {
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview().inset(8)
        }
    }
    
    // MARK: - Functions

    func setup(with preview: UIImage?) {
        imageView.image = preview
    }

}
