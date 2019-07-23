//
//  TemplateCollectionViewCell.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 27.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol StoryRemoveDelegate: class {
    func deleteTemplate(_ template: Template?)
}

class TemplateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(deleteItemTouch), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
        return button
    }()
    
    private weak var delegate: StoryRemoveDelegate? {
        didSet {
            deleteButton.isHidden = delegate == nil
        }
    }
    
    private lazy var previewImageView = UIImageView()
    
    private var template: Template?
    
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
    
    // MARK: - Actions
    
    @objc private func deleteItemTouch() {
        delegate?.deleteTemplate(template)
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        contentView.addSubview(previewImageView)
        contentView.addSubview(deleteButton)
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        deleteButton.snp.remakeConstraints { maker in
            maker.top.right.equalToSuperview()
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        previewImageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    // MARK: - Function
    
    func setup(with previewImage: UIImage?, delegate: StoryRemoveDelegate?, template: Template) {
        previewImageView.image = previewImage
        self.delegate = delegate
        self.template = template
    }
    
}



