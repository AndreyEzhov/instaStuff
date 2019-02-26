//
//  StorySlideCell.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class StorySlideCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var slide: StorySlide?
    
    private var photoPlaces: [PhotoPlace] = []
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        guard let slide = slide else {
            return
        }
        zip(photoPlaces, slide.template.photoAreas).forEach { (arg) in
            let (place, path) = arg
            let scaledPath = path
            place.snp.remakeConstraints { maker in
                maker.width.equalTo(scaledPath.bounds.width)
                maker.height.equalTo(scaledPath.bounds.height)
                //maker.center.equalTo(scaledPath.bounds.center)
            }
            let mask = CAShapeLayer()
            mask.path = scaledPath.cgPath
            place.layer.mask = mask
        }
    }
    
    // MARK: - Function
    
    func setup(with slide: StorySlide) {
        self.slide = slide
        contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        photoPlaces.removeAll()
        slide.template.photoAreas.forEach { _ in
            let photoPlace = PhotoPlace()
            contentView.addSubview(photoPlace)
            photoPlaces.append(photoPlace)
        }
        photoPlaces.first?.backgroundColor = .red
        photoPlaces.last?.backgroundColor = .green
        setNeedsUpdateConstraints()
    }
    
}
