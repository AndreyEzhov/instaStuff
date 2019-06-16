//
//  PipetteSubview.swift
//  InstaStuff
//
//  Created by aezhov on 15/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class PipetteSubview: UIView {

    // MARK: - Proeprties
    
    private lazy var pixelView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var displayView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    weak var view: UIView? {
        didSet {
            currentTranslation = CGPoint.zero
        }
    }
    
    var completion: ((UIColor?) -> ())?
    
    private var currentTranslation = CGPoint.zero {
        didSet {
            displayView.transform = CGAffineTransform(translationX: currentTranslation.x, y: currentTranslation.y)
            pixelView.transform = CGAffineTransform(translationX: currentTranslation.x, y: currentTranslation.y)
            updateColor()
        }
    }
    
    // MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pixelView.layer.cornerRadius = pixelView.bounds.width / 2
        displayView.layer.cornerRadius = displayView.bounds.width / 2
    }
    
    override func updateConstraints() {
        displayView.snp.remakeConstraints { maker in
            maker.size.equalTo(CGSize.init(width: 60, height: 60))
            maker.centerX.equalTo(pixelView)
        }
        pixelView.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.size.equalTo(CGSize.init(width: 6, height: 6))
            maker.top.equalTo(displayView.snp.bottom).offset(30)
        }
        super.updateConstraints()
    }
    
    // MARK: - Functions
    
    private func setup() {
        addSubview(pixelView)
        addSubview(displayView)
        setNeedsUpdateConstraints()
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer()
        addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(panGesture(_:)))
    }
    
    // MARK: - Actions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        currentTranslation = CGPoint(x: location.x - pixelView.frame.midX, y: location.y - pixelView.frame.midY)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        completion?(pixelView.backgroundColor)
        view?.removeFromSuperview()
        removeFromSuperview()
    }
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.setTranslation(currentTranslation, in: self)
        case .changed:
            currentTranslation = sender.translation(in: self)
            updateColor()
        case .ended:
            completion?(pixelView.backgroundColor)
            view?.removeFromSuperview()
            removeFromSuperview()
        default:
            break
        }
    }
    
    private func updateColor() {
        guard let color = pixelColor() else { return }
        updateColor(with: color)
    }
    
    private func pixelColor() -> UIColor? {
        guard let view = view else { return nil }
        let newPoint = CGPoint(x: pixelView.frame.midX, y: pixelView.frame.midY)
        return getPixelColorAtPoint(point: newPoint, sourceView: view)
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
    
    private func updateColor(with color: UIColor) {
        pixelView.backgroundColor = color
        displayView.backgroundColor = color
    }

}
