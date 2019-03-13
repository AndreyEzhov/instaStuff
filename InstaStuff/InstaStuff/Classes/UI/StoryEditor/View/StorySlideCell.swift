//
//  StorySlideCell.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

typealias UIViewTemplatePlaceble = (UIView & TemplatePlaceble)

class StorySlideCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let backgroundImageView =  UIImageView()
    
    private var slide: StorySlide?
    
    private(set) var photoPlaces: [UIViewTemplatePlaceble] = []
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let slide = slide else {
            return
        }
        backgroundImageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        photoPlaces.enumerated().forEach { arg in
            let (offset, place) = arg
            let frameArea = slide.template.frameAreas[offset]
            place.snp.remakeConstraints { maker in
                maker.center.equalTo(CGPoint(x: frameArea.settings.center.x * frame.width,
                                             y: frameArea.settings.center.y * frame.height))
                maker.width.equalToSuperview().multipliedBy(frameArea.settings.sizeWidth)
                maker.width.equalTo(place.snp.height).multipliedBy(frameArea.settings.ratio)
            }
            updateTransform(for: place)
        }
    }
    
    // MARK: - Private Functions
    
    private func updateTransform(for view: (UIView & TemplatePlaceble)) {
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: view.storyEditableItem.settings.angle)
        view.transform = transform
    }
    
    // MARK: - Function
    
    func setup(with slide: StorySlide) {
        self.slide = slide
        contentView.clipsToBounds = true
        contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        photoPlaces.removeAll()
        contentView.addSubview(backgroundImageView)
        slide.items.enumerated().forEach { arg in
            var view: UIViewTemplatePlaceble?
            switch arg.element {
            case let item as StoryEditablePhotoItem:
                view = PhotoPlace(item)
            case let item as StoryEditableTextItem:
                view = MemeLabelView(item, isEditable: false)
            case let item as StoryEditableStuffItem:
                view = StuffPlace(item)
            default:
                break
            }
            if let view = view {
                photoPlaces.append(view)
                view.tag = arg.offset
                contentView.addSubview(view)
            }
        }
        backgroundImageView.image = slide.template.backgroundImage
        setNeedsUpdateConstraints()
    }
    
}
