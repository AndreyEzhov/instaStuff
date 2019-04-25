//
//  AppWindow.swift
//  InstaStuff
//
//  Created by aezhov on 25/04/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class AppWindow: UIWindow {
    
    var colorCallBack: ((UIColor?) -> ())?
    
    override func sendEvent(_ event: UIEvent) {
        if let callback = colorCallBack, event.type == .touches, let view = self.subviews.first, let position = event.allTouches?.first?.location(in: view) {
            let color = getPixelColorAtPoint(point: position, sourceView: view)
            callback(color)
            colorCallBack = nil
        } else {
            super.sendEvent(event)
        }
    }
    
    private func getPixelColorAtPoint(point: CGPoint, sourceView: UIView) -> UIColor? {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        var color: UIColor? = nil
        
        if let context = context {
            context.translateBy(x: -point.x, y: -point.y)
            sourceView.layer.render(in: context)
            
            color = UIColor(red: CGFloat(pixel[0])/255.0,
                            green: CGFloat(pixel[1])/255.0,
                            blue: CGFloat(pixel[2])/255.0,
                            alpha: CGFloat(pixel[3])/255.0)
            
            pixel.deallocate()
        }
        return color
    }
}
