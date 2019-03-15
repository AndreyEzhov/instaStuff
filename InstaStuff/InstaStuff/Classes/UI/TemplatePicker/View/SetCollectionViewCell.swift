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
    
    private var templateSet: TemplateSet? {
        didSet {
            applyStyle()
        }
    }
    
    private lazy var setTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Consts.Colors.r112g112b112
        label.textAlignment = .center
        label.font = UIFont(name: UIFont.chalkboard, size: 8)
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet { setTappedState(isHighlighted, animated: true) }
    }
    
    override var isSelected: Bool {
        didSet {
            applyStyle()
        }
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
        contentView.addSubview(setTitleLabel)
        setNeedsUpdateConstraints()
        contentView.layer.cornerRadius = 11
        contentView.layer.borderWidth = 1.0
        dropShadow()
        isSelected = false
    }
    
    private func applyStyle() {
        if isSelected {
            contentView.layer.borderWidth = 0.0
            contentView.backgroundColor = templateSet?.themeColor
            layer.shadowOpacity = 0.16
        } else {
            contentView.layer.borderWidth = 1.0
            contentView.backgroundColor = .clear
            layer.shadowOpacity = 0
        }
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        setTitleLabel.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview().inset(2)
        }
    }
    
    // MARK: - Function
    
    func setup(with templateSet: TemplateSet) {
        self.templateSet = templateSet
        setTitleLabel.text = templateSet.name
        contentView.layer.borderColor = templateSet.themeColor.cgColor
    }
    
}
