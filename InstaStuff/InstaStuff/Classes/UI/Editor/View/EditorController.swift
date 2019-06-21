//
//  EditorController.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

private struct Constants {
    static let toolbarHeight: CGFloat = 44
}

/// Контроллер для экрана «Editor»
final class EditorController: BaseViewController<EditorPresentable>, EditorDisplayable {
    
    // MARK: - Properties
    
    /// Есть ли сториборд
    override class var hasStoryboard: Bool { return false }
    
    private lazy var editorToolbar: EditorToolbar = {
        let view = EditorToolbar()
        view.setup(presenter)
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .top
        return stackView
    }()
    
    var contentSize: CGSize {
        let modulesHeight = presenter.modules.reduce(CGFloat.zero) { (res, model) -> CGFloat in
            return res + model.height
        }
        return CGSize(width: UIScreen.main.bounds.width,
                      height: Constants.toolbarHeight + modulesHeight)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Consts.Colors.applicationColor
        setup()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        editorToolbar.snp.remakeConstraints { maker in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(Constants.toolbarHeight)
        }
        stackView.snp.remakeConstraints { maker in
            maker.left.right.bottomMargin.equalToSuperview()
            maker.top.equalTo(editorToolbar.snp.bottom)
        }
    }
    
    // MARK: - EditorDisplayable
    
    func updateContent(old: [EditModule], new: [EditModule]) {
        old.forEach { unembedChildViewController($0.controller) }
        stackView.arrangedSubviews.forEach(stackView.removeArrangedSubview)
        new.forEach { module in
            let contentView = UIView()
            embedChildViewController(module.controller, toView: contentView)
            stackView.addArrangedSubview(contentView)
            contentView.snp.remakeConstraints({ maker in
                maker.height.equalTo(module.height)
                maker.width.equalToSuperview()
            })
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        view.addSubview(editorToolbar)
        view.addSubview(stackView)
        updateViewConstraints()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
}
