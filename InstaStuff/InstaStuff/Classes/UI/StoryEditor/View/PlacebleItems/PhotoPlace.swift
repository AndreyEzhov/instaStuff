//
//  PhotoPlace.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 24.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift

protocol PhotoPicker: class {
    func photoPlaceDidSelected(_ photoPlace: PhotoPlace, completion: @escaping (UIImage) -> ())
    func photoPlaceDidBeginEditing(_ photoPlace: PhotoPlace)
    func photoPlaceDidEndEditing(_ photoPlace: PhotoPlace)
}

protocol TemplatePlaceble: class {
    var storyEditableItem: StoryEditableItem { get }
}

class PhotoPlace: UIViewTemplatePlaceble, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    var storyEditableItem: StoryEditableItem {
        return storyEditablePhotoItem
    }
    
    let storyEditablePhotoItem: StoryEditablePhotoItem
    
    private lazy var photoContentView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let dashedLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.black.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1 / UIScreen.main.scale
        return layer
    }()
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var framePlace: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var deletePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
        return button
    }()
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private var photoRedactorValue: Float = 0
    
    override var inputView: UIView? {
        if hasPhoto {
            let view = Assembly.shared.createPhotoModuleControllerController(params: PhotoModuleControllerPresenter.Parameters(initilaValue: photoRedactorValue))
            view.delegate = self
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 140)
            return view
        } else {
            return nil
        }
    }
    
    private let bag = DisposeBag()
    
    weak var delegate: PhotoPicker?
    
    private var gestures: [UIGestureRecognizer] = []
    
    private var hasPhoto: Bool {
        if let image = ((try? storyEditablePhotoItem.image.value()) as UIImage??), image == nil {
            return false
        }
        return true
    }
    
    private var currentMinimumScale: CGFloat = 1
    
    // MARK: - Construction
    
    init(_ storyEditablePhotoItem: StoryEditablePhotoItem) {
        self.storyEditablePhotoItem = storyEditablePhotoItem
        super.init(frame: .zero)
        setup()
        setupGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashedLayer.frame = photoContentView.frame
        dashedLayer.path = UIBezierPath(rect: dashedLayer.bounds).cgPath
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        photoContentView.snp.remakeConstraints { maker in
            let settings = storyEditablePhotoItem.photoItem.photoAreaLocation
            maker.width.equalTo(photoContentView.snp.height).multipliedBy(settings.ratio)
            maker.width.equalToSuperview().multipliedBy(settings.sizeWidth)
            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2)
            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2)
        }
        photoImageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        framePlace.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        let closeButtonPosition = storyEditablePhotoItem.customSettings?.closeButtonPosition ?? PhotoItemCustomSettings.CloseButtonPosition.rightTop
        deletePhotoButton.snp.remakeConstraints { maker in
            switch closeButtonPosition {
            case .leftTop:
                maker.top.equalTo(photoContentView.snp.top)
                maker.left.equalTo(photoContentView.snp.left)
            case .leftBottom:
                maker.bottom.equalTo(photoContentView.snp.bottom)
                maker.left.equalTo(photoContentView.snp.left)
            case .rightTop:
                maker.top.equalTo(photoContentView.snp.top)
                maker.right.equalTo(photoContentView.snp.right)
            case .rightBottom:
                maker.bottom.equalTo(photoContentView.snp.bottom)
                maker.right.equalTo(photoContentView.snp.right)
            }
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let location = storyEditablePhotoItem.photoItem.photoAreaLocation
        Consts.Colors.photoplaceColor.setFill()
        let realCenterX = location.center.x * rect.width
        let realCenterY = location.center.y * rect.height
        let widthRect = location.sizeWidth * rect.width
        let hightRect = widthRect / location.ratio
        let xRect = realCenterX - widthRect / 2
        let yRect = realCenterY - hightRect / 2
        UIBezierPath(rect: CGRect(x: xRect,
                                  y: yRect,
                                  width: widthRect,
                                  height: hightRect)).fill()
        Consts.Colors.applicationTintColor.setStroke()
        let lineSize: CGFloat = min(widthRect * 0.5, 15)
        
        var plussCenter = CGPoint(x: realCenterX, y: realCenterY)
        if let plusLocation = storyEditablePhotoItem.customSettings?.plusLocation {
            plussCenter = CGPoint(x: plusLocation.x * rect.width, y: plusLocation.y * rect.height)
        }
        
        let vPath = UIBezierPath()
        vPath.move(to: CGPoint(x: plussCenter.x - lineSize, y: plussCenter.y))
        vPath.addLine(to: CGPoint(x: plussCenter.x + lineSize, y: plussCenter.y))
        vPath.close()
        vPath.lineWidth = 1 / UIScreen.main.scale
        vPath.stroke()
        
        let hPath = UIBezierPath()
        hPath.move(to: CGPoint(x: plussCenter.x, y: plussCenter.y - lineSize))
        hPath.addLine(to: CGPoint(x: plussCenter.x, y: plussCenter.y + lineSize))
        hPath.close()
        hPath.lineWidth = vPath.lineWidth
        hPath.stroke()
    }
    
    // MARK: - Actions
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
        case .changed:
            storyEditablePhotoItem.editablePhotoTransform.currentTranslation = sender.translation(in: self)
            updateTransforms()
        default:
            break
        }
    }
    
    @objc private func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.rotation = storyEditablePhotoItem.editablePhotoTransform.currentRotation
        case .changed:
            storyEditablePhotoItem.editablePhotoTransform.currentRotation = sender.rotation
            updateTransforms()
        default:
            break
        }
    }
    
    @objc private func zoomGesture(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.scale = storyEditablePhotoItem.editablePhotoTransform.currentScale
        case .changed:
            storyEditablePhotoItem.editablePhotoTransform.currentScale = max(currentMinimumScale, sender.scale)
            updateTransforms()
        default:
            break
        }
    }
    
    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        guard hasPhoto else {
            delegate?.photoPlaceDidSelected(self) { image in
                self.storyEditablePhotoItem.update(image: image)
            }
            return
        }
        _ = becomeFirstResponder()
    }
    
    @objc private func deletePhoto() {
        storyEditablePhotoItem.update(image: nil)
        updateTransforms()
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        backgroundColor = .clear
        addSubview(photoContentView)
        photoContentView.addSubview(photoImageView)
        addSubview(framePlace)
        addSubview(deletePhotoButton)
        layer.addSublayer(dashedLayer)
        
        storyEditablePhotoItem.image.subscribe(onNext: { [weak self] image in
            guard let sSelf = self else { return }
            sSelf.photoImageView.image = image
            if let image = image {
                _ = sSelf.becomeFirstResponder()
                var scale = sSelf.storyEditablePhotoItem.photoItem.photoAreaLocation.ratio / (image.size.width / image.size.height)
                if scale < 1 {
                    scale = 1 / scale
                }
                sSelf.storyEditablePhotoItem.editablePhotoTransform.currentScale = scale
                sSelf.currentMinimumScale = scale
                sSelf.updateTransforms()
            } else {
                _ = sSelf.resignFirstResponder()
            }
            self?.reloadInputViews()
        }).disposed(by: bag)
        framePlace.image = storyEditablePhotoItem.photoItem.framePlaceImage
        
        clipsToBounds = true
        deletePhotoButton.isHidden = true
        updateConstraintsIfNeeded()
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer()
        photoContentView.addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(panGesture(_:)))
        pan.delegate = self
        
        let rotation = UIRotationGestureRecognizer()
        photoContentView.addGestureRecognizer(rotation)
        rotation.addTarget(self, action: #selector(rotateGesture(_:)))
        rotation.delegate = self
        
        let zoom = UIPinchGestureRecognizer()
        photoContentView.addGestureRecognizer(zoom)
        zoom.addTarget(self, action: #selector(zoomGesture(_:)))
        zoom.delegate = self
        
        let tap = UITapGestureRecognizer()
        photoContentView.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(tapGesture(_:)))
        tap.delegate = self
        
        gestures = [pan, rotation, zoom]
    }
    
    private func updateTransforms() {
        photoImageView.transform = storyEditablePhotoItem.editablePhotoTransform.transform
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestures.contains(gestureRecognizer) && gestures.contains(otherGestureRecognizer)
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            return true
        }
        if isFirstResponder {
            return gestures.contains(gestureRecognizer)
        } else {
            return !gestures.contains(gestureRecognizer)
        }
    }
    
    // MARK: - UIResponder
    
    override func resignFirstResponder() -> Bool {
        let flag = super.resignFirstResponder()
        dashedLayer.lineDashPattern = isFirstResponder ? nil : [2, 2]
        deletePhotoButton.isHidden = !isFirstResponder
        delegate?.photoPlaceDidEndEditing(self)
        return flag
    }
    
    override func becomeFirstResponder() -> Bool {
        let flag = super.becomeFirstResponder()
        dashedLayer.lineDashPattern = isFirstResponder ? nil : [2, 2]
        deletePhotoButton.isHidden = !isFirstResponder
        if hasPhoto {
            delegate?.photoPlaceDidBeginEditing(self)
        }
        return flag
    }
    
}

let queue = DispatchQueue(label: "myImageQueue", qos: .background)

extension PhotoPlace: SliderListener {
    
    func valueDidChanged(_ value: Float) {
        DispatchQueue.global(qos: .background).async {
            self.photoRedactorValue = value
            guard let imageOpt = ((try? self.storyEditablePhotoItem.image.value()) as UIImage??), let image = imageOpt else {
                return
            }
            if let originalImage = CIImage(image: image) {
                let outputImage = originalImage.applyingFilter("CIColorControls",
                                                               parameters: [
                                                                kCIInputImageKey: originalImage,
                                                                //kCIInputSaturationKey: 1.0 - 0.07 * value,
                                                                kCIInputContrastKey: 1.0 - 0.2 * value,
                                                                //kCIInputBrightnessKey: -0.06 * value,
                                                                ])
                let newImage = UIImage(ciImage: outputImage)
                DispatchQueue.main.async {
                    self.photoImageView.image = newImage
                }
            }
        }
    }
    
}
