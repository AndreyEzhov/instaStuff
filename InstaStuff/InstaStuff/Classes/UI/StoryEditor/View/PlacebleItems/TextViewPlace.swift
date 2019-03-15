//
//  TextViewPlace.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift

class TextViewPlace: UITextView, TemplatePlaceble {
    
    // MARK: - Properties
    
    let storyEditableTextItem: StoryEditableTextItem
    
    var storyEditableItem: StoryEditableItem {
        return storyEditableTextItem
    }
    
    private let bag = DisposeBag()
    
    var isSelected = false {
        didSet {
            layer.borderColor = UIColor.black.cgColor
            layer.cornerRadius = 3
            layer.borderWidth = isSelected ? 1 : 0
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
    
    // MARK: - Private Functions
    
    private func setup() {
        storyEditableTextItem.text.asObservable().subscribe(onNext: { [weak self] text in
            self?.text = text
        }).disposed(by: bag)
        backgroundColor = .clear
        isScrollEnabled = false
        isSelected = false
        addDoneButtonOnKeyboard()
    }
    
    private func updateTextSetup() {
        let setups = storyEditableTextItem.textItem.textSetups
        var newFont = UIFont.systemFont(ofSize: 16)
        if setups.textType.contains(.bold) {
            newFont = newFont.bold()
        }
        if setups.textType.contains(.italic) {
            newFont = newFont.italic()
        }
    }
    
    // MARK: - UIResponder
    
    override func becomeFirstResponder() -> Bool {
        let becomeFirstResponder = super.becomeFirstResponder()
        isSelected = becomeFirstResponder
        return becomeFirstResponder
    }
    
    override func resignFirstResponder() -> Bool {
        let resignFirstResponder = super.resignFirstResponder()
        isSelected = !resignFirstResponder
        return resignFirstResponder
    }

}
