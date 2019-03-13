//
//  MemeLabel.swift
//  MyMem
//
//  Created by Андрей Ежов on 13.01.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import SnapKit

protocol EditableObject: class {
    var color: UIColor? { get set }
    var font: UIFont! { get set }
}

class MemeLabel: UILabel, EditableObject {
    
    // MARK: - Properties
    
    static private let defaultStrokeWidth: CGFloat = -1.0
    
    static private let defaultFontSize: CGFloat = 18.0
    
    override var font: UIFont! {
        didSet {
            super.font = font.withSize(MemeLabel.defaultFontSize * currentScale)
        }
    }
    
    var color: UIColor? {
        didSet {
            textColor = color
        }
    }
    
    var currentScale: CGFloat = 1.0 {
        didSet {
            font = font.withSize(MemeLabel.defaultFontSize * currentScale)
        }
    }
    
    override var text: String? {
        didSet {
            attributedText = NSAttributedString(string: text ?? "",
                                                attributes: attributes)
        }
    }
    
    var attributes: [NSAttributedString.Key : Any] {
        let size = MemeLabel.defaultFontSize * currentScale
        let font = self.font
            ?? UIFont.systemFont(ofSize: size)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        return [
            .font: font,
            .foregroundColor: color ?? UIColor.black,
            .strokeColor: UIColor.white,
            .strokeWidth: MemeLabel.defaultStrokeWidth,
            .paragraphStyle: style
        ]
    }
    
    // MARK: - Construction
    
    init() {
        super.init(frame: .zero)
        numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
