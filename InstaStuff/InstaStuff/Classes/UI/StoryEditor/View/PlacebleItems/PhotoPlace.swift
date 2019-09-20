//
//  PhotoPlace.swift
//  InstaStuff
//
//  Created by aezhov on 31/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoPlace: UIViewTemplatePlaceble {
    
    // MARK: - Properties
    
    private lazy var framePlace = UIImageView()
    
    private lazy var photoLayerView: PhotoLayerView = {
        let view = PhotoLayerView()
        view.addGestureRecognizer(pickImageTapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let imageHandler: ImageHandler
    
    private(set) lazy var pickImageTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.delegate = self
        return gesture
    }()
 
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        storyEditablePhotoItem.imageName.subscribe(onNext: { [weak self] name in
            let image = self?.imageHandler.loadImage(named: name)
            view.image = image
            if let image = image, let photoPlaceRatio = self?.storyEditablePhotoItem.ratio {
                var settings = Settings(center: CGPoint(x: 0.5, y: 0.5),
                                        sizeWidth: 1,
                                        angle: 0)
                self?.storyEditablePhotoItem.photoItem.photoPositionSettings = settings
            }
        }).disposed(by: bag)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var storyEditableItem: StoryEditableItem {
        return storyEditablePhotoItem
    }
    
    let storyEditablePhotoItem: StoryEditablePhotoItem
    
    private let bag = DisposeBag()
    
    // MARK: - Contruction
    
    init(_ storyEditablePhotoItem: StoryEditablePhotoItem, imageHandler: ImageHandler) {
        self.imageHandler = imageHandler
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
        imageView.snp.remakeConstraints { maker in
            let settings = storyEditablePhotoItem.photoItem.photoPositionSettings
            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2)
            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2)
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
    
    func updatePhoto(_ photo: UIImage?) {
        imageView.image = photo
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        addSubview(photoLayerView)
        addSubview(framePlace)
        photoLayerView.addSubview(imageView)
        framePlace.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        photoLayerView.snp.remakeConstraints { maker in
            let settings = storyEditablePhotoItem.photoItem.photoInFrameSettings
            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2)
            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2)
            maker.width.equalTo(photoLayerView.snp.height).multipliedBy(settings.ratio)
            maker.width.equalToSuperview().multipliedBy(settings.sizeWidth)
        }
        update(with: storyEditablePhotoItem.photoItem)
        setupGestures()
    }
    
    private func setupGestures() {
        
    }
    
}

extension PhotoPlace: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === pickImageTapGesture {
            return storyEditablePhotoItem.imageName.value == nil
        }
        return true
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
