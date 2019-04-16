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

class TextViewPlace: UITextView, TemplatePlaceble {
    
    // MARK: - Properties
    
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
    
    // MARK: - Construction
    
    init(_ item: StoryEditableTextItem) {
        storyEditableTextItem = item
        super.init(frame: .zero, textContainer: nil)
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
    
    // MARK: - Private Functions
    
    private func setup() {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        storyEditableTextItem.text.asObservable().bind(to: rx.text).disposed(by: bag)
        rx.text.orEmpty.subscribe(onNext: { [weak self] (string) in
            self?.storyEditableTextItem.text.onNext(string)
            self?.attributedText = NSAttributedString(string: string, attributes: self?.storyEditableTextItem.textSetups.attributes)
        }).disposed(by: bag)
        storyEditableTextItem.textSetups.attributesSubject.asObservable().subscribe(onNext: { [weak self] attributes in
            self?.attributedText = NSAttributedString(string: self?.text ?? "", attributes: attributes)
        }).disposed(by: bag)
        backgroundColor = .clear
        isScrollEnabled = false
        isSelected = false
        addDoneButtonOnKeyboard()
        layer.addSublayer(dashedLayer)
        layoutManager.allowsNonContiguousLayout = false
        addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
    }
    
    // MARK: - UIResponder
    
    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        isSelected = isFirstResponder
        TextViewPlace.editView.presenter.textSetups = storyEditableTextItem.textSetups
        return becomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        isSelected = isFirstResponder
        return resignFirstResponder
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            alignVerticaly()
        }
    }
    
    private func alignVerticaly() {
        var topoffset = bounds.size.height - contentSize.height * zoomScale / 2.0
        topoffset = topoffset < 0.0 ? 0.0 : topoffset
        contentOffset = CGPoint(x: 0, y: -topoffset)
    }
    
}
