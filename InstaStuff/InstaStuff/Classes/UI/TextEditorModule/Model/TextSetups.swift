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
    
    let aligment: Aligment
    
    let fontSize: CGFloat
    
    let lineSpacing: CGFloat
    
    let fontType: FontEnum
    
    let kern: CGFloat
    
    let color: ColorEnum
    
}

class TextSetupsEditable {
    
    // MARK: - Properties
    
    var attributes: [NSAttributedString.Key : Any] {
        return attributes(with: Consts.UIGreed.globalScale)
    }
    
    var realAttributes: [NSAttributedString.Key : Any] {
        return attributes(with: 1)
    }
    
    private(set) var textType: TextSetups.TextType
    
    private(set) var aligment: Aligment
    
    private(set) var fontType: FontEnum
    
    private(set) var capitalised: Bool = false
    
    var color: ColorEnum {
        didSet {
            attributesSubject.onNext(attributes)
        }
    }
    
    var kern: CGFloat {
        didSet {
            attributesSubject.onNext(attributes)
        }
    }
    
    var lineSpacing: CGFloat {
        didSet {
            attributesSubject.onNext(attributes)
        }
    }
    
    var fontSize: CGFloat {
        didSet {
            attributesSubject.onNext(attributes)
        }
    }
    
    let attributesSubject: BehaviorSubject<[NSAttributedString.Key : Any]>
    
    var isBold: Bool {
        return textType.contains(.bold)
    }
    
    var isItalic: Bool {
        return textType.contains(.italic)
    }
    
    var canBeBold: Bool {
        return textType.contains(.bold)
    }
    
    var canBeItalic: Bool {
        return textType.contains(.italic)
    }
    
    let isUpperCaseSubject: BehaviorSubject<Bool>
    
    private(set) var isUpperCase = false {
        didSet {
            isUpperCaseSubject.onNext(isUpperCase)
        }
    }
    
    // MARK: - Construction
    
    init(textSetups: TextSetups) {
        textType = textSetups.textType
        fontSize = textSetups.fontSize
        aligment = textSetups.aligment
        fontType = textSetups.fontType
        kern = textSetups.kern
        color = textSetups.color
        lineSpacing = textSetups.lineSpacing
        isUpperCaseSubject = BehaviorSubject(value: isUpperCase)
        attributesSubject = BehaviorSubject(value: [:])
        attributesSubject.onNext(attributes)
        updateBoldItalic()
    }
    
    private func attributes(with coef: CGFloat) -> [NSAttributedString.Key : Any] {
        return [.font: font(with: coef),
                .kern: kern * coef,
                .foregroundColor: color.color,
                .paragraphStyle: NSParagraphStyle.default {
                    $0.alignment = aligment.textAlignment
                    $0.lineSpacing = lineSpacing * coef
            }]
    }
    
    private func font(with coef: CGFloat) -> UIFont {
        var newFont = UIFont(name: fontType.name, size: fontSize * coef) ?? UIFont.systemFont(ofSize: fontSize * coef)
        if textType.contains(.bold) {
            newFont = newFont.bold()
        }
        if textType.contains(.italic) {
            newFont = newFont.italic()
        }
        return newFont
    }
    
    private func updateBoldItalic() {
        guard let font = UIFont(name: fontType.name, size: 1) else {
            return
        }
        if textType.contains(.bold), font.canBeBold == false {
            textType.remove(.bold)
        }
        if textType.contains(.italic), font.canBeItalic == false {
            textType.remove(.italic)
        }
    }
    
    // MARK: - Functions
    
    func makeBold() {
        if textType.contains(.bold) {
            textType.remove(.bold)
        } else {
            textType.insert(.bold)
        }
        attributesSubject.onNext(attributes)
    }
    
    func makeItalic() {
        if textType.contains(.italic) {
            textType.remove(.italic)
        } else {
            textType.insert(.italic)
        }
        attributesSubject.onNext(attributes)
    }
    
    func upperCase() {
        isUpperCase = !isUpperCase
    }
    
    func changeAlignment() {
        if let index = Aligment.allCases.firstIndex(of: aligment) {
            if index + 1 == Aligment.allCases.count {
                aligment = Aligment(rawValue: 0) ?? .left
            } else {
                aligment = Aligment(rawValue: index + 1) ?? .left
            }
        }
        attributesSubject.onNext(attributes)
    }
    
    func update(with font: FontEnum) {
        fontType = font
        updateBoldItalic()
        attributesSubject.onNext(attributes)
    }
    
}
