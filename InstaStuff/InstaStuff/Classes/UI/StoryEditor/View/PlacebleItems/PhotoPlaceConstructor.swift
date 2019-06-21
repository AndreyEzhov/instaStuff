//
//  PhotoPlaceConstructor.swift
//  InstaStuff
//
//  Created by aezhov on 15/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift

extension PhotoPlaceConstructor: SliderListener {
    
    func valueDidChanged(_ value: Float) {
        DispatchQueue.global(qos: .background).async {
            self.photoRedactorValue = value
            guard let imageOpt = ((try? self.storyEditablePhotoItem.image.value()) as UIImage??), let image = imageOpt else {
                return
            }
            if let originalImage = CIImage(image: image) {
                let outputImage = originalImage.applyingFilter("CISepiaTone",
                                                               parameters: [
                                                                kCIInputImageKey: originalImage,
                                                                kCIInputIntensityKey: Float(Int(value * 100)) / 100,
                    ])
                let newImage = UIImage(ciImage: outputImage)
                DispatchQueue.main.async {
                    self.photoImageView.image = newImage
                }
            }
        }
    }
    
}

class PhotoPlaceConstructor: UIViewTemplatePlaceble, UIGestureRecognizerDelegate {
    
    enum Mode {
        case none, selcted, edited
    }
    
    // MARK: - Properties
    
    var mode = Mode.none {
        didSet {
            updateMode()
        }
    }
    
    var storyEditableItem: StoryEditableItem {
        return storyEditablePhotoItem
    }
    
    private(set) var storyEditablePhotoItem: StoryEditablePhotoItem
    
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
    
    private var photoRedactorValue: Float = 0
    
    private let bag = DisposeBag()
    
    private var gestures: [UIGestureRecognizer] = []
    
    private var image: UIImage?
    
    private var vibratedX = false
    
    private var vibratedY = false
    
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
        if round {
            photoContentView.layer.cornerRadius = photoContentView.bounds.width / 2.0
        } else {
            photoContentView.layer.cornerRadius = 0
        }
        layer.cornerRadius = photoContentView.layer.cornerRadius
        let roundedRect = dashedLayer.bounds.insetBy(dx: 1 / UIScreen.main.scale / 2.0, dy: 1 / UIScreen.main.scale / 2.0)
        dashedLayer.path = UIBezierPath(roundedRect: roundedRect, cornerRadius: photoContentView.layer.cornerRadius == 0 ? 0 : roundedRect.width / 2.0).cgPath
        setNeedsDisplay()
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
            if let image = self.image {
                let photoRatio = image.size.width/image.size.height
                let settings = storyEditablePhotoItem.photoItem.photoAreaLocation
                maker.width.equalTo(photoImageView.snp.height).multipliedBy(photoRatio)
                if photoRatio < settings.ratio {
                    maker.left.equalToSuperview()
                } else {
                    maker.top.equalToSuperview()
                }
            }
            maker.center.equalToSuperview()
        }
        framePlace.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.masksToBounds = true
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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superView = superview?.superview as? UIGestureRecognizerDelegate else {
            return
        }
        gestures.forEach { $0.delegate = superView }
    }
    
    // MARK: - Actions
    
    private var catchedLocationX: CGFloat? = 0
    
    private var catchedLocationY: CGFloat? = 0
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
            catchedLocationX = nil
            catchedLocationY = nil
            vibratedX = false
            vibratedY = false
        case .changed:
            guard storyEditablePhotoItem.editablePhotoTransform.currentRotation == 0 else {
                storyEditablePhotoItem.editablePhotoTransform.currentTranslation = sender.translation(in: self)
                updateTransforms()
                return
            }
            let oldTransform = storyEditablePhotoItem.editablePhotoTransform.transform
            storyEditablePhotoItem.editablePhotoTransform.currentTranslation = sender.translation(in: self)
            
            let frame = photoImageView.frame.applying(oldTransform.inverted()).applying(storyEditablePhotoItem.editablePhotoTransform.transform)
            let space = 10
            var currentTranslation: CGPoint {
                return storyEditablePhotoItem.editablePhotoTransform.currentTranslation
            }
            
            if -space...space ~= Int(frame.minX) {
                if catchedLocationX == nil {
                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.minX, y: currentTranslation.y)
                } else if let catchedLocationX = catchedLocationX {
                    let difference = catchedLocationX - sender.location(in: self).x
                    if abs(difference) < CGFloat(space) {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.minX, y: currentTranslation.y)
                    } else {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.minX - difference, y: currentTranslation.y)
                    }
                }
                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
                if !vibratedX {
                    catchedLocationX = sender.location(in: self).x
                    vibratedX = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else if (frame.maxX < (photoContentView.bounds.width + CGFloat(space))) && (frame.maxX > (photoContentView.bounds.width - CGFloat(space))) {
                if catchedLocationX == nil {
                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.maxX + photoContentView.bounds.width, y: currentTranslation.y)
                } else if let catchedLocationX = catchedLocationX {
                    let difference = catchedLocationX - sender.location(in: self).x
                    if abs(difference) < CGFloat(space) {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.maxX + photoContentView.bounds.width, y: currentTranslation.y)
                    } else {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.maxX + photoContentView.bounds.width - difference, y: currentTranslation.y)
                    }
                }
                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
                if !vibratedX {
                    catchedLocationX = sender.location(in: self).x
                    vibratedX = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                catchedLocationX = nil
                vibratedX = false
            }
            
            if -space...space ~= Int(frame.minY) {
                if catchedLocationY == nil {
                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.minY)
                } else if let catchedLocationY = catchedLocationY {
                    let difference = catchedLocationY - sender.location(in: self).y
                    if abs(difference) < CGFloat(space) {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.minY)
                    } else {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.minY - difference)
                    }
                }
                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
                if !vibratedY {
                    catchedLocationY = sender.location(in: self).y
                    vibratedY = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else if (frame.maxY < (photoContentView.bounds.height + CGFloat(space))) && (frame.maxY > (photoContentView.bounds.height - CGFloat(space))) {
                if catchedLocationY == nil {
                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.maxY + photoContentView.bounds.height)
                } else if let catchedLocationY = catchedLocationY {
                    let difference = catchedLocationY - sender.location(in: self).y
                    if abs(difference) < CGFloat(space) {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.maxY + photoContentView.bounds.height)
                    } else {
                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.maxY + photoContentView.bounds.height - difference)
                    }
                }
                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
                if !vibratedY {
                    catchedLocationY = sender.location(in: self).y
                    vibratedY = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            } else {
                catchedLocationY = nil
                vibratedY = false
            }
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
            storyEditablePhotoItem.editablePhotoTransform.currentScale = sender.scale
            updateTransforms()
        default:
            break
        }
    }
    
    @objc private func doubleTapGesture(_ sender: UITapGestureRecognizer) {
        storyEditablePhotoItem.editablePhotoTransform.identity()
        UIView.animate(withDuration: 0.3) {
            self.updateTransforms()
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        backgroundColor = .clear
        addSubview(photoContentView)
        photoContentView.addSubview(photoImageView)
        addSubview(framePlace)
        layer.addSublayer(dashedLayer)
        
        storyEditablePhotoItem.image.subscribe(onNext: { [weak self] image in
            guard let sSelf = self else { return }
            sSelf.image = image
            sSelf.photoImageView.image = image
            if let image = image {
                _ = sSelf.becomeFirstResponder()
                sSelf.updateTransforms()
            } else {
                _ = sSelf.resignFirstResponder()
            }
            self?.updateConstraints()
            self?.reloadInputViews()
        }).disposed(by: bag)
        framePlace.image = storyEditablePhotoItem.photoItem.framePlaceImage
        
        clipsToBounds = false
        updateMode()
        updateConstraintsIfNeeded()
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer()
        photoContentView.addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(panGesture(_:)))
        
        let rotation = UIRotationGestureRecognizer()
        photoContentView.addGestureRecognizer(rotation)
        rotation.addTarget(self, action: #selector(rotateGesture(_:)))
        
        let zoom = UIPinchGestureRecognizer()
        photoContentView.addGestureRecognizer(zoom)
        zoom.addTarget(self, action: #selector(zoomGesture(_:)))
        
        let doubleTap = UITapGestureRecognizer()
        photoContentView.addGestureRecognizer(doubleTap)
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(doubleTapGesture(_:)))
        doubleTap.delegate = self
        
        gestures = [pan, rotation, zoom]
    }
    
    private func updateTransforms() {
        photoImageView.transform = storyEditablePhotoItem.editablePhotoTransform.transform
    }
    
    // MARK: - Functions
    
    func selectAsEditable(delegate: ConstructorItemDelegate) {
        if mode == .none {
            mode = .selcted
        }
    }
    
    func selectAsNotEditable() {
        mode = .none
    }
    
    func updateMode() {
        switch mode {
        case .selcted:
            break
        case .none:
            break
        case .edited:
            break
        }
    }
    
    var round = false
    
    func modify(with settings: PhotoPlaceConstructorSettings) {
        if settings.photoItem.frameName.contains("round") {
            round = true
        } else {
            round = false
        }
        storyEditablePhotoItem.photoItem = settings.photoItem
        storyEditablePhotoItem.settings = settings.settings
        framePlace.image = storyEditablePhotoItem.photoItem.framePlaceImage
        updateConstraints()
    }
}
