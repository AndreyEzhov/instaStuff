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
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        storyEditableTextItem.text.asObservable().bind(to: rx.text).disposed(by: bag)
        rx.text.orEmpty.bind(to: storyEditableTextItem.text).disposed(by: bag)
        storyEditableTextItem.textSetups.attributesSubject.asObservable().subscribe(onNext: { [weak self] attributes in
            self?.attributedText = NSAttributedString(string: self?.text ?? "", attributes: attributes)
        }).disposed(by: bag)
        backgroundColor = .clear
        isScrollEnabled = false
        isSelected = false
        addDoneButtonOnKeyboard()
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

}
