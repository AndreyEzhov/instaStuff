//
//  MemeLabelView.swift
//  MyMem
//
//  Created by Андрей Ежов on 18.01.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift

class MemeLabelView: UIViewTemplatePlaceble {
    
    // MARK: - Properties
    
    private let isEditable: Bool
    
    let storyEditableTextItem: StoryEditableTextItem
    
    var storyEditableItem: StoryEditableItem {
        return storyEditableTextItem
    }
    
    let memeLabel: MemeLabel = {
        let label = MemeLabel()
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        return label
    }()
    
    private let widthIndicatorView = SizeControllerView()
    
    private let closeButton = CloseButton()
    
    private var translationWidth: CGFloat = 0.0
    
    var editablePhotoTransform = EditableTransform()
    
    var isSelected: Bool = false {
        didSet {
            widthIndicatorView.isHidden = !isSelected
            closeButton.isHidden = !isSelected
            memeLabel.layer.borderColor = (isSelected ? UIColor.black : .clear).cgColor
        }
    }
    
    private let bag = DisposeBag()
    
    // MARK: - Construction
    
    init(_ storyEditableTextItem: StoryEditableTextItem, isEditable: Bool) {
        self.storyEditableTextItem = storyEditableTextItem
        self.isEditable = isEditable
        super.init(frame: .zero)
        setupViews()
        setupGestures()
        storyEditableTextItem.text.subscribe(onNext: { [weak self] text in
            self?.memeLabel.text = text
        }).disposed(by: bag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard isEditable else {
            return
        }
        guard let view = superview else {
            return
        }
        self.snp.remakeConstraints { maker in
            maker.width.equalTo(view.frame.width * 0.9)
            maker.height.greaterThanOrEqualTo(40.0)
        }
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        guard isEditable else {
            memeLabel.snp.remakeConstraints { maker in
                maker.edges.equalToSuperview()
            }
            return
        }
        closeButton.snp.remakeConstraints { maker in
            maker.left.top.equalToSuperview()
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        closeButton.layer.cornerRadius = 15.0
        
        widthIndicatorView.snp.remakeConstraints { maker in
            maker.right.bottom.equalToSuperview()
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
        widthIndicatorView.layer.cornerRadius = 15.0
        
        memeLabel.snp.remakeConstraints { maker in
            maker.bottom.top.equalToSuperview()
            maker.left.equalTo(closeButton.snp.right)
            maker.right.equalTo(widthIndicatorView.snp.left)
        }
    }
    
    // MARK: - Private Functions
    
    private func setupViews() {
        defer {
            setNeedsUpdateConstraints()
        }
        addSubview(memeLabel)
        guard isEditable else {
            return
        }
        addSubview(widthIndicatorView)
        addSubview(closeButton)
    }
    
    private func setupGestures() {
        guard isEditable else {
            return
        }
        let panGesture = UIPanGestureRecognizer()
        widthIndicatorView.addGestureRecognizer(panGesture)
        panGesture.addTarget(self, action: #selector(changeWidth(_:)))
    }
    
    // MARK: - Functions
    
    func setupTarget(_ target: Any?, action: Selector) {
        let tragets = closeButton.allTargets
        tragets.forEach{ closeButton.removeTarget($0, action: nil, for: .allEvents)}
        closeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    // MARK: - Gestures
    
    @objc private func changeWidth(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            let translation = sender.translation(in: self).x
            self.snp.remakeConstraints { maker in
                let width = max(80, translationWidth + translation)
                maker.width.equalTo(width)
                maker.height.greaterThanOrEqualTo(40.0)
            }
        default:
            translationWidth = self.frame.width
        }
    }
}

