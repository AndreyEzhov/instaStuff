//
//  TextSetups.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift

struct TextSetups {
    
    struct TextType: OptionSet {
        let rawValue: Int
        
        static let bold = TextType(rawValue: 1 << 0)
        static let italic = TextType(rawValue: 1 << 1)
    }

    let textType: TextType
    
    let fontSize: CGFloat

}

class TextSetupsEditable {
    
    // MARK: - Properties

    private var attributes: [NSAttributedString.Key : Any] {
        return attributes(with: globalScale)
    }
    
    var realAttributes: [NSAttributedString.Key : Any] {
        return attributes(with: 1)
    }
    
    let textType: TextSetups.TextType
    
    let fontSize: CGFloat
    
    let attributesSubject: BehaviorSubject<[NSAttributedString.Key : Any]>
    
    // MARK: - Construction
    
    init(textSetups: TextSetups) {
        textType = textSetups.textType
        fontSize = textSetups.fontSize
        attributesSubject = BehaviorSubject(value: [:])
        attributesSubject.onNext(attributes)
    }
    
    private func attributes(with coef: CGFloat) -> [NSAttributedString.Key : Any] {
        return [.font: font(with: coef),
                .kern: 1 * coef]
    }
    
    private func font(with coef: CGFloat) -> UIFont {
        var newFont = UIFont(name: UIFont.chalkboard, size: fontSize * coef) ?? UIFont.systemFont(ofSize: fontSize * coef)
        if textType.contains(.bold) {
            newFont = newFont.bold()
        }
        if textType.contains(.italic) {
            newFont = newFont.italic()
        }
        return newFont
    }
    
}
