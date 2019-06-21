//
//  EditorToolbar.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

@objc protocol EditorToolbarProtocol: class {
    @objc func collapseTouch()
    @objc func doneTouch()
}

class EditorToolbar: UIView {

    // MARK: - Properties
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "badge-check"), for: .normal)
        return button
    }()
    
    private lazy var collapseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrowBottom"), for: .normal)
        return button
    }()
    
    var isCollapsed: Bool = false {
        didSet {
            collapseButton.transform = isCollapsed ? CGAffineTransform(rotationAngle: .pi) : .identity
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
        addSubview(doneButton)
        addSubview(collapseButton)
        doneButton.snp.remakeConstraints { maker in
            maker.right.top.bottom.equalToSuperview()
            maker.width.equalTo(80)
        }
        collapseButton.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.equalToSuperview()
            maker.width.equalTo(80)
        }
    }
    
    // MARK: - Functions
    
    func setup(_ target: EditorToolbarProtocol?) {
        doneButton.removeTarget(nil, action: nil, for: .allEvents)
        collapseButton.removeTarget(nil, action: nil, for: .allEvents)
       
        doneButton.addTarget(target, action: #selector(target?.doneTouch), for: .touchUpInside)
        collapseButton.addTarget(target, action: #selector(target?.collapseTouch), for: .touchUpInside)
    }

}
