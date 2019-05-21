//
//  MenuView.swift
//  InstaStuff
//
//  Created by aezhov on 14/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

@objc protocol MenuViewProtocol: class {
    @objc func addPhotoAction(_ sender: UIButton)
    @objc func addItemAction(_ sender: UIButton)
    @objc func addTextAction(_ sender: UIButton)
    @objc func changeBackgroundAction(_ sender: UIButton)
}

class MenuView: UIView {

    // MARK: - Properties
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(addPhotoButton)
        stackView.addArrangedSubview(addItemButton)
        stackView.addArrangedSubview(addTextButton)
        stackView.addArrangedSubview(changeBackgroundButton)
        return stackView
    }()
    
    private(set) lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addPhoto"), for: .normal)
        return button
    }()
    
    private(set) lazy var addItemButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addItem"), for: .normal)
        return button
    }()
    
    private(set) lazy var addTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addText"), for: .normal)
        return button
    }()
    
    private(set) lazy var changeBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "changeBackground"), for: .normal)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = CGRect.init(x: 0, y: 0, width: bounds.width, height: bounds.height - Consts.UIGreed.safeAreaInsetsBottom)
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        addSubview(stackView)
    }
    
    // MARK: - Functions
    
    func setupActions(for target: MenuViewProtocol) {
        addPhotoButton.addTarget(target, action: #selector(MenuViewProtocol.addPhotoAction(_:)), for: .touchUpInside)
        addItemButton.addTarget(target, action: #selector(MenuViewProtocol.addItemAction(_:)), for: .touchUpInside)
        addTextButton.addTarget(target, action: #selector(MenuViewProtocol.addTextAction(_:)), for: .touchUpInside)
        changeBackgroundButton.addTarget(target, action: #selector(MenuViewProtocol.changeBackgroundAction(_:)), for: .touchUpInside)
    }

}
