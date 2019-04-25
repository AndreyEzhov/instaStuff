//
//  TextViewPlace.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextViewPlace: UIView, TemplatePlaceble {
    
    // MARK: - Properties
    
    private(set) lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.isScrollEnabled = false
        textView.layoutManager.allowsNonContiguousLayout = false
        textView.backgroundColor = .clear
        textView.autocorrectionType = .no
        return textView
    }()
    
    let storyEditableTextItem: StoryEditableTextItem
    
    var storyEditableItem: StoryEditableItem {
        return storyEditableTextItem
    }
    
    private let dashedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1 / UIScreen.main.scale
        return layer
    }()
    
    private let bag = DisposeBag()
    
    var isSelected = false {
        didSet {
            dashedLayer.lineDashPattern = isSelected ? nil : [2, 2]
        }
    }
    
    let colorPickerModule = ColorPickerModule()
    
    // MARK: - Construction
    
    init(_ item: StoryEditableTextItem) {
        storyEditableTextItem = item
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedLayer.frame = layer.bounds
        dashedLayer.path = UIBezierPath(rect: dashedLayer.bounds.inset(by: UIEdgeInsets(top: 1 / UIScreen.main.scale, left: 1 / UIScreen.main.scale, bottom: 1 / UIScreen.main.scale, right: 1 / UIScreen.main.scale))).cgPath
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        textView.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.center.equalToSuperview()
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        
        addSubview(textView)
        
        storyEditableTextItem.text.asObservable().bind(to: textView.rx.text).disposed(by: bag)
        
        textView.rx.text.orEmpty.subscribe(onNext: { [weak self] string in
            guard let sSelf = self else { return }
            sSelf.storyEditableTextItem.text.onNext(string)
            sSelf.textView.attributedText = NSAttributedString(string: string, attributes: sSelf.storyEditableTextItem.textSetups.attributes)
        }).disposed(by: bag)
        
        storyEditableTextItem.textSetups.attributesSubject.asObservable().subscribe(onNext: { [weak self] attributes in
            self?.textView.attributedText = NSAttributedString(string: self?.textView.text ?? "", attributes: attributes)
        }).disposed(by: bag)
        
        backgroundColor = .clear
        isSelected = false
        addDoneButtonOnKeyboard()
        layer.addSublayer(dashedLayer)
        setupTap()
    }
    
    private func setupTap() {
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(tapGesture(_:)))
        let tapTV = UITapGestureRecognizer()
        textView.addGestureRecognizer(tapTV)
        tapTV.addTarget(self, action: #selector(tapGesture(_:)))
    }
    
    // MARK: - Actions
    
    @objc private func tapGesture(_ gesture: UITapGestureRecognizer) {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        } else {
            textView.becomeFirstResponder()
            TextViewPlace.editView.update(colorPickerModule: colorPickerModule)
            TextViewPlace.editView.presenter.textSetups = storyEditableTextItem.textSetups
        }
        isSelected = textView.isFirstResponder
    }

    
}
