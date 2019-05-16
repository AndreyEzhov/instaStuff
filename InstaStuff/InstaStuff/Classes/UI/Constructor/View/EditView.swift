//
//  EditView.swift
//  InstaStuff
//
//  Created by aezhov on 16/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class EditView: UIView {
    
    // MARK: - Properties
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "deleteItem"), for: .normal)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "editItem"), for: .normal)
        return button
    }()
    
    private lazy var toTopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "moveToBack"), for: .normal)
        return button
    }()
    
    private lazy var toBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "moveToFront"), for: .normal)
        return button
    }()

    // MARK: - Construction
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        deleteButton.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.top.equalToSuperview()
            maker.right.equalToSuperview()
        }
        editButton.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.top.equalToSuperview()
            maker.left.equalToSuperview()
        }
        toTopButton.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.bottom.equalToSuperview()
            maker.right.equalToSuperview()
        }
        toBackgroundButton.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.bottom.equalToSuperview()
            maker.left.equalToSuperview()
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        backgroundColor = .clear
        addSubview(deleteButton)
        addSubview(editButton)
        addSubview(toTopButton)
        addSubview(toBackgroundButton)
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Functions
    
    func setup(target: ConstructorItemDelegate) {
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
        deleteButton.addTarget(target, action: #selector(ConstructorItemDelegate.removeItem), for: .touchUpInside)
        
        editButton.removeTarget(nil, action: nil, for: .allEvents)
        editButton.addTarget(target, action: #selector(ConstructorItemDelegate.editItem), for: .touchUpInside)
        
        toTopButton.removeTarget(nil, action: nil, for: .allEvents)
        toTopButton.addTarget(target, action: #selector(ConstructorItemDelegate.itemToTop), for: .touchUpInside)
        
        toBackgroundButton.removeTarget(nil, action: nil, for: .allEvents)
        toBackgroundButton.addTarget(target, action: #selector(ConstructorItemDelegate.itemToBackground), for: .touchUpInside)
    }
}
