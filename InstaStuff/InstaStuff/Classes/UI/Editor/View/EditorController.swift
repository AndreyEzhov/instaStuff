//
//  EditorController.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Контроллер для экрана «Editor»
final class EditorController: BaseViewController<EditorPresentable>, EditorDisplayable {
    
    struct Constants {
        static let toolbarHeight: CGFloat = 44
    }
    
    // MARK: - Properties
    
    private(set) lazy var editorToolbar: EditorToolbar = {
        let view = EditorToolbar()
        view.setup(presenter)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var stackView: UIView = {
        let stackView = UIView()
        stackView.backgroundColor = .clear
        return stackView
    }()
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Consts.Colors.applicationColor
        setup()
    }
    
    override func updateViewConstraints() {
        editorToolbar.snp.remakeConstraints { maker in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(Constants.toolbarHeight)
        }
        stackView.snp.remakeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(editorToolbar.snp.bottom)
        }
        super.updateViewConstraints()
    }
    
    // MARK: - EditorDisplayable
    
    func updateContent(old: [EditModule], new: [EditModule]) {
        old.forEach { unembedChildViewController($0.controller) }
        stackView.subviews.forEach { $0.removeFromSuperview() }
        new.forEach { module in
            let contentView = UIView()
            embedChildViewController(module.controller, toView: contentView)
            stackView.addSubview(contentView)
            contentView.snp.remakeConstraints({ maker in
                maker.height.equalTo(module.height)
                maker.left.right.equalToSuperview()
                let topViewIndex = stackView.subviews.count - 2
                if topViewIndex >= 0 {
                    maker.top.equalTo(stackView.subviews[topViewIndex].snp.bottom)
                } else {
                    maker.top.equalToSuperview()
                }
            })
        }
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        view.addSubview(editorToolbar)
        view.addSubview(stackView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
}
