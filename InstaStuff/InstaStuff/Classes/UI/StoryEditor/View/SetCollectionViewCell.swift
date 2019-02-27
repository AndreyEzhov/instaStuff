//
//  SetCollectionViewCell.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 26.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class SetCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var setTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Consts.Colors.r112g112b112
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
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
        contentView.addSubview(setTitleLabel)
        setNeedsUpdateConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = bounds.height / 2.0
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1.0
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        setTitleLabel.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    // MARK: - Function
    
    func setup(with templateSet: TemplateSet) {
        setTitleLabel.text = templateSet.name
    }
    
}
