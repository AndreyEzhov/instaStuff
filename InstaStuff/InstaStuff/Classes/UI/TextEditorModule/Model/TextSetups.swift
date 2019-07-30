//
//  TextSetups.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TextSetups {
    
    static var defaultSetups: TextSetups {
        return TextSetups.init(aligment: .center,
                               fontSize: 40,
                               lineSpacing: 1,
                               fontType: .cheque,
                               kern: 1,
                               color: .black,
                               backgroundColor: .clear,
                               currentText: "Type your text")
    }
    
    let attributesSubject: BehaviorSubject<Void>
    
    let currentText: BehaviorRelay<String>
    
    var aligment: Aligment {
        didSet {
            attributesSubject.onNext(())
        }
    }
    
    var fontSize: CGFloat {
        didSet {
            attributesSubject.onNext(())
        }
    }
    
    var lineSpacing: CGFloat {
        didSet {
            attributesSubject.onNext(())
        }
    }
    
    var fontType: FontEnum {
        didSet {
            attributesSubject.onNext(())
        }
    }
    
    var kern: CGFloat {
        didSet {
            attributesSubject.onNext(())
        }
    }
    
    var color: UIColor {
        didSet {
            attributesSubject.onNext(())
        }
    }
    
    var backgroundColor: UIColor {
        didSet {
            attributesSubject.onNext(())
        }
    }
    
    init(aligment: Aligment, fontSize: CGFloat, lineSpacing: CGFloat, fontType: FontEnum, kern: CGFloat, color: UIColor, backgroundColor: UIColor, currentText: String) {
        self.aligment = aligment
        self.fontSize = fontSize
        self.lineSpacing = lineSpacing
        self.fontType = fontType
        self.kern = kern
        self.color = color
        self.backgroundColor = backgroundColor
        self.currentText = BehaviorRelay(value: currentText)
        
        attributesSubject = BehaviorSubject(value: ())
    }
    
    // MARK: - Functions
    
    func changeAlignment() {
        if let index = Aligment.allCases.firstIndex(of: aligment) {
            if index + 1 == Aligment.allCases.count {
                aligment = Aligment(rawValue: 0) ?? .left
            } else {
                aligment = Aligment(rawValue: index + 1) ?? .left
            }
        }
    }
    
    func update(with font: FontEnum) {
        fontType = font
    }
    
    func upperCase() {
        var text = currentText.value
        let uppercased = text.uppercased()
        if text == uppercased {
            text = text.capitalized
        } else {
            text = uppercased
        }
        currentText.accept(text)
    }
    
    func copy() -> TextSetups {
        return TextSetups(aligment: aligment, fontSize: fontSize, lineSpacing: lineSpacing, fontType: fontType, kern: kern, color: color, backgroundColor: backgroundColor, currentText: currentText.value)
    }
    
    // MARK: - Private Functions
    
    func attributes(with coef: CGFloat) -> [NSAttributedString.Key : Any] {
        return [.font: font(with: coef),
                .kern: kern * coef,
                .foregroundColor: color,
                .paragraphStyle: NSParagraphStyle.default {
                    $0.alignment = aligment.textAlignment
                    $0.lineSpacing = lineSpacing * coef
            }]
    }
    
    private func font(with coef: CGFloat) -> UIFont {
        return UIFont(name: fontType.name, size: fontSize * coef) ?? UIFont.systemFont(ofSize: fontSize * coef)
    }
    
}
