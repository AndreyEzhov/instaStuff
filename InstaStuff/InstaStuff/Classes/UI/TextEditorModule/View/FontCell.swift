//
//  FontCell.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class FontCell: UICollectionViewCell {
    
    struct Constants {
        static let inset: CGFloat = 6
        static let fontSize: CGFloat = 14
    }
    
    // MARK: - Properties
    
    private lazy var fontLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var font: FontEnum!
    
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
        fontLabel.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview().inset(Constants.inset)
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        contentView.addSubview(fontLabel)
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Functions
    
    func setup(with font: FontEnum) {
        self.font = font
        fontLabel.font = UIFont(name: font.name, size: Constants.fontSize) ?? UIFont.applicationFontRegular(ofSize: Constants.fontSize)
        fontLabel.text = font.name
    }
    
}
