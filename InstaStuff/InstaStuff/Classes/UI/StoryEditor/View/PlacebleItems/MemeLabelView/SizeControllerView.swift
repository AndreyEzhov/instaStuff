//
//  SizeButton.swift
//  MyMem
//
//  Created by Андрей Ежов on 27.01.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class SizeControllerView: UIView {
    
    // MARK: - Construction
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func draw(_ rect: CGRect) {
        let centerY = 0.5 * rect.height
        let offset: CGFloat = 1
        let rect = CGRect.init(x: offset, y: offset, width: rect.width - 2 * offset, height: rect.height - 2 * offset)
        let path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        UIColor.white.setStroke()
        
        path.fill()
        path.stroke()
        
        let arrowSize: CGFloat = 0.4
        let lineWidht: CGFloat = 2.0
        let lineSize: CGFloat = 0.5
        let padding: CGFloat = offset + (1 - lineSize) * rect.width / 2
        let size: CGFloat = 0.6 * rect.width - 2 * offset
        let coordinatOffset: CGFloat = arrowSize * size * CGFloat(cos(Double.pi / 4))
        
        let lines: [((CGFloat, CGFloat), (CGFloat, CGFloat))] = [
            ((padding, centerY), (padding + size, centerY)),
            ((padding, centerY), (padding + coordinatOffset, centerY - coordinatOffset)),
            ((padding, centerY), (padding + coordinatOffset, centerY + coordinatOffset)),
            ((padding + size, centerY), (padding + size - coordinatOffset, centerY - coordinatOffset)),
            ((padding + size, centerY), (padding + size - coordinatOffset, centerY + coordinatOffset))
        ]
        
        lines.forEach {
            let ((x1, y1), (x2, y2)) = $0
            let path = UIBezierPath()
            path.lineWidth = lineWidht
            path.move(to: CGPoint(
                x: x1,
                y: y1))
            path.addLine(to: CGPoint(
                x: x2,
                y: y2))
            path.stroke()
        }
    }
}
