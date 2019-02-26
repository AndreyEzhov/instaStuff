//
//  StoryCell.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 25.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StoryCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var deleteBlock: (() -> ())?
    
    private weak var story: StoryItem?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .yellow
        button.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        return button
    }()
    
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
        imageView.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize(width: 60, height: 60))
        }
        deleteButton.snp.remakeConstraints { maker in
            maker.top.right.equalToSuperview()
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.15
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    // MARK: - Actions
    
    @objc private func deleteAction() {
        deleteBlock?()
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        contentView.backgroundColor = .white
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    func setup(with story: StoryItem, deleteBlock: @escaping (() -> ())) {
        self.story = story
        self.deleteBlock = deleteBlock
    }
    
}

