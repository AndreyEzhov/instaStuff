//
//  CloseButton.swift
//  MyMem
//
//  Created by Андрей Ежов on 27.01.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class CloseButton: UIButton {
    
    // MARK: - Properties
    
    override var buttonType: UIButton.ButtonType {
        return .system
    }
    
    override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // MARK: - Construction
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func draw(_ rect: CGRect) {
        let mainColor = isHighlighted ? UIColor.red.withAlphaComponent(0.6) : UIColor.red
        let offset: CGFloat = 1
        let rect = CGRect.init(x: offset, y: offset, width: rect.width - 2 * offset, height: rect.height - 2 * offset)
        let path = UIBezierPath(ovalIn: rect)
        mainColor.setFill()
        UIColor.white.setStroke()
        
        path.fill()
        path.stroke()
        
        let lineWidht: CGFloat = 2.0
        let lineSize: CGFloat = 0.5
        let padding: CGFloat = offset + (1 - lineSize) * rect.width / 2
        let size: CGFloat = 0.6 * rect.width - 2 * offset
        
        ([0.0, 1.0] as [CGFloat]).forEach {
            let plusPath = UIBezierPath()
            plusPath.lineWidth = lineWidht
            plusPath.move(to: CGPoint(
                x: padding,
                y: padding + size * $0))
            plusPath.addLine(to: CGPoint(
                x: padding + size,
                y: padding + size - size * $0))
            plusPath.stroke()
        }
    }
}
