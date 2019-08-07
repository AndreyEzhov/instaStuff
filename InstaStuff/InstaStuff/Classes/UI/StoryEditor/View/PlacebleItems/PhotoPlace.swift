//
//  PhotoPlace.swift
//  InstaStuff
//
//  Created by aezhov on 31/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class PhotoPlace: UIViewTemplatePlaceble {
    
    // MARK: - Properties
    
    private lazy var framePlace = UIImageView()
    
    private lazy var photoLayerView = PhotoLayerView()
    
    var storyEditableItem: StoryEditableItem {
        return storyEditablePhotoItem
    }
    
    let storyEditablePhotoItem: StoryEditablePhotoItem
    
    // MARK: - Contruction
    
    init(_ storyEditablePhotoItem: StoryEditablePhotoItem) {
        self.storyEditablePhotoItem = storyEditablePhotoItem
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoLayerView.layer.cornerRadius = photoLayerView.bounds.width * storyEditablePhotoItem.photoItem.photoInFrameSettings.round
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        photoLayerView.snp.remakeConstraints { maker in
            let settings = storyEditablePhotoItem.photoItem.photoInFrameSettings
            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2)
            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2)
            maker.width.equalTo(photoLayerView.snp.height).multipliedBy(settings.ratio)
            maker.width.equalToSuperview().multipliedBy(settings.sizeWidth)
        }
    }
    
    // MARK: - Functions
    
    func update(with item: PhotoItem) {
        storyEditablePhotoItem.photoItem = item
        framePlace.image = storyEditablePhotoItem.photoItem.framePlaceImage
        updateConstraints()
        layoutIfNeeded()
        photoLayerView.setNeedsDisplay()
    }
    
    
    // MARK: - Private Functions
    
    private func setup() {
        addSubview(photoLayerView)
        addSubview(framePlace)
        framePlace.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        update(with: storyEditablePhotoItem.photoItem)
    }
    
}


class PhotoLayerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        Consts.Colors.photoplaceColor.setFill()
        UIBezierPath(rect: rect).fill()
        Consts.Colors.applicationTintColor.setStroke()
        let lineSize: CGFloat = min(rect.width * 0.5, 15)
        
        let vPath = UIBezierPath()
        vPath.move(to: CGPoint(x: rect.midX - lineSize, y: rect.midY))
        vPath.addLine(to: CGPoint(x: rect.midX + lineSize, y: rect.midY))
        vPath.close()
        vPath.lineWidth = 1 / UIScreen.main.scale
        vPath.stroke()
        
        let hPath = UIBezierPath()
        hPath.move(to: CGPoint(x: rect.midX, y: rect.midY - lineSize))
        hPath.addLine(to: CGPoint(x: rect.midX, y: rect.midY + lineSize))
        hPath.close()
        hPath.lineWidth = vPath.lineWidth
        hPath.stroke()
    }
    
}
