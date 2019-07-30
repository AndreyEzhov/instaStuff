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
    
    private(set) var storyEditableTextItem: StoryEditableTextItem
    
    var storyEditableItem: StoryEditableItem {
        return storyEditableTextItem
    }
    
    private let dashedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = nil
        layer.lineDashPattern = [2, 2]
        return layer
    }()
    
    var isSelected = false {
        didSet {
            dashedLayer.lineWidth = isSelected ? (1 / UIScreen.main.scale) : 0
        }
    }
    
    private let coef: CFloat
    
    private let bag = DisposeBag()
    
    override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }
    
    private let square: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()
    
    // MARK: - Construction
    
    init(_ item: StoryEditableTextItem, coef: CFloat) {
        self.coef = coef
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
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        square.frame = textView.frame
        dashedLayer.frame = layer.bounds
        dashedLayer.path = UIBezierPath(rect: dashedLayer.bounds.inset(by: UIEdgeInsets(top: 1 / UIScreen.main.scale, left: 1 / UIScreen.main.scale, bottom: 1 / UIScreen.main.scale, right: 1 / UIScreen.main.scale))).cgPath
        updateBackground()
        CATransaction.commit()
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
        layer.addSublayer(dashedLayer)
        layer.addSublayer(square)
        addSubview(textView)
        backgroundColor = .clear
        addDoneButtonOnKeyboard()
        setupTap()
        isSelected = false
        
        storyEditableTextItem.textItem.textSetups.currentText.subscribe(onNext: { [weak self] text in
            guard let sSelf = self else { return }
            let attributes = sSelf.storyEditableTextItem.textItem.textSetups.attributes(with: CGFloat(sSelf.coef))
            sSelf.textView.attributedText = NSAttributedString(string: text, attributes: attributes)
            sSelf.updateBackground()
        }).disposed(by: bag)
        
        Observable.combineLatest(textView.rx.text.orEmpty.distinctUntilChanged(), storyEditableTextItem.textItem.textSetups.attributesSubject).subscribe(onNext: { [weak self] (text, _) in
            guard let sSelf = self else { return }
            sSelf.storyEditableTextItem.textItem.textSetups.currentText.accept(text)
        }).disposed(by: bag)
        
        textView.rx.didEndEditing.subscribe(onNext: { [weak self] _ in
            self?.isSelected = false
        }).disposed(by: bag)
        
        textView.rx.didBeginEditing.subscribe(onNext: { [weak self] _ in
            self?.isSelected = true
        }).disposed(by: bag)
    }
    
    private func updateBackground() {
        //        var rects = [CGRect]()
//        let path = UIBezierPath()
//        textView.layoutManager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, textView.text.count)) { (rect, usedRect, textContainer, glyphRange, stop) in
//            path.append(UIBezierPath(rect: usedRect.inset(by: UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4))))
//            rects.append(usedRect)
//        }
        //        var points = [CGPoint]()
        //        rects.forEach { rect in
        //            points.append(CGPoint(x: rect.maxX, y: rect.minY))
        //            points.append(CGPoint(x: rect.maxX, y: rect.maxY))
        //        }
        //        rects.reversed().forEach { rect in
        //            points.append(CGPoint(x: rect.minX, y: rect.maxY))
        //            points.append(CGPoint(x: rect.minX, y: rect.minY))
        //        }
        
//        path.close()
//        square.path = path.cgPath
//        square.fillColor = storyEditableTextItem.textItem.textSetups.backgroundColor.cgColor
//        path.fill()
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
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
}
