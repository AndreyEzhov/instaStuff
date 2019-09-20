////
////  PhotoPlace.swift
////  InstaStuff
////
////  Created by Андрей Ежов on 24.02.2019.
////  Copyright © 2019 Андрей Ежов. All rights reserved.
////
//
import UIKit
import RxSwift

@objc protocol ConstructorItemDelegate: class {
    @objc func removeItem()
    @objc func editItem()
    @objc func itemToTop()
    @objc func itemToBackground()
}

protocol TemplatePlaceble: class {
    var storyEditableItem: StoryEditableItem { get }
    func selectAsEditable(delegate: ConstructorItemDelegate)
    func selectAsNotEditable()
}

extension TemplatePlaceble {
    func selectAsEditable(delegate: ConstructorItemDelegate) { }
    func selectAsNotEditable() { }
}
//
//class PhotoPlaceOld: UIViewTemplatePlaceble, UIGestureRecognizerDelegate {
//
//    // MARK: - Properties
//    
//    var storyEditableItem: StoryEditableItem {
//        return storyEditablePhotoItem
//    }
//
//    let storyEditablePhotoItem: StoryEditablePhotoItem
//
//    private lazy var photoContentView: UIView = {
//        let view = UIView()
//        view.clipsToBounds = true
//        return view
//    }()
//
//    private let dashedLayer: CAShapeLayer = {
//        let layer = CAShapeLayer()
//        layer.strokeColor = UIColor.black.cgColor
//        layer.fillColor = nil
//        layer.lineWidth = 1 / UIScreen.main.scale
//        return layer
//    }()
//
//    private lazy var photoImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    private lazy var framePlace: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//
//    private lazy var deletePhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
//        button.addTarget(self, action: #selector(deletePhoto), for: .touchUpInside)
//        return button
//    }()
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    private var photoRedactorValue: Float = 0
//
//    override var inputView: UIView? {
//        if hasPhoto {
//            let view = Assembly.shared.createPhotoModuleControllerController(params: PhotoModuleControllerPresenter.Parameters(initilaValue: photoRedactorValue))
//            view.delegate = self
//            return view
//        } else {
//            return nil
//        }
//    }
//
//    private let bag = DisposeBag()
//
//    weak var delegate: PhotoPicker?
//
//    private var gestures: [UIGestureRecognizer] = []
//
//    private var hasPhoto: Bool {
//        return image != nil
//    }
//
//    private var image: UIImage?
//
//    private var vibratedX = false
//
//    private var vibratedY = false
//
//    // MARK: - Construction
//
//    init(_ storyEditablePhotoItem: StoryEditablePhotoItem) {
//        self.storyEditablePhotoItem = storyEditablePhotoItem
//        super.init(frame: .zero)
//        setup()
//        setupGestures()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Life Cycle
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        dashedLayer.frame = photoContentView.frame
//        dashedLayer.path = UIBezierPath(rect: dashedLayer.bounds).cgPath
//    }
//
//    override func updateConstraints() {
//        super.updateConstraints()
////        photoContentView.snp.remakeConstraints { maker in
////            let settings = storyEditablePhotoItem.photoItem.photoAreaLocation
////            maker.width.equalTo(photoContentView.snp.height).multipliedBy(settings.ratio)
////            maker.width.equalToSuperview().multipliedBy(settings.sizeWidth)
////            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2)
////            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2)
////        }
////        photoImageView.snp.remakeConstraints { maker in
////            if let image = self.image {
////                let photoRatio = image.size.width/image.size.height
////                let settings = storyEditablePhotoItem.photoItem.photoAreaLocation
////                maker.width.equalTo(photoImageView.snp.height).multipliedBy(photoRatio)
////                if photoRatio < settings.ratio {
////                    maker.left.equalToSuperview()
////                } else {
////                    maker.top.equalToSuperview()
////                }
////            }
////            maker.center.equalToSuperview()
////        }
////        framePlace.snp.remakeConstraints { maker in
////            maker.edges.equalToSuperview()
////        }
////        let closeButtonPosition = storyEditablePhotoItem.customSettings?.closeButtonPosition ?? PhotoItemCustomSettings.CloseButtonPosition.rightTop
////        deletePhotoButton.snp.remakeConstraints { maker in
////            switch closeButtonPosition {
////            case .leftTop:
////                maker.top.equalTo(photoContentView.snp.top)
////                maker.left.equalTo(photoContentView.snp.left)
////            case .leftBottom:
////                maker.bottom.equalTo(photoContentView.snp.bottom)
////                maker.left.equalTo(photoContentView.snp.left)
////            case .rightTop:
////                maker.top.equalTo(photoContentView.snp.top)
////                maker.right.equalTo(photoContentView.snp.right)
////            case .rightBottom:
////                maker.bottom.equalTo(photoContentView.snp.bottom)
////                maker.right.equalTo(photoContentView.snp.right)
////            }
////            maker.size.equalTo(CGSize(width: 30, height: 30))
////        }
//    }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
////        let location = storyEditablePhotoItem.photoItem.photoAreaLocation
////        Consts.Colors.photoplaceColor.setFill()
////        let realCenterX = location.center.x * rect.width
////        let realCenterY = location.center.y * rect.height
////        let widthRect = location.sizeWidth * rect.width
////        let hightRect = widthRect / location.ratio
////        let xRect = realCenterX - widthRect / 2
////        let yRect = realCenterY - hightRect / 2
////        UIBezierPath(rect: CGRect(x: xRect,
////                                  y: yRect,
////                                  width: widthRect,
////                                  height: hightRect)).fill()
////        Consts.Colors.applicationTintColor.setStroke()
////        let lineSize: CGFloat = min(widthRect * 0.5, 15)
////
////        var plussCenter = CGPoint(x: realCenterX, y: realCenterY)
////        if let plusLocation = storyEditablePhotoItem.customSettings?.plusLocation {
////            plussCenter = CGPoint(x: plusLocation.x * rect.width, y: plusLocation.y * rect.height)
////        }
////
////        let vPath = UIBezierPath()
////        vPath.move(to: CGPoint(x: plussCenter.x - lineSize, y: plussCenter.y))
////        vPath.addLine(to: CGPoint(x: plussCenter.x + lineSize, y: plussCenter.y))
////        vPath.close()
////        vPath.lineWidth = 1 / UIScreen.main.scale
////        vPath.stroke()
////
////        let hPath = UIBezierPath()
////        hPath.move(to: CGPoint(x: plussCenter.x, y: plussCenter.y - lineSize))
////        hPath.addLine(to: CGPoint(x: plussCenter.x, y: plussCenter.y + lineSize))
////        hPath.close()
////        hPath.lineWidth = vPath.lineWidth
////        hPath.stroke()
//    }
//
//    // MARK: - Actions
//
//    private var catchedLocationX: CGFloat? = 0
//
//    private var catchedLocationY: CGFloat? = 0
//
//    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
////        switch sender.state {
////        case .began:
////            sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
////            catchedLocationX = nil
////            catchedLocationY = nil
////            vibratedX = false
////            vibratedY = false
////        case .changed:
////            guard storyEditablePhotoItem.editablePhotoTransform.currentRotation == 0 else {
////                storyEditablePhotoItem.editablePhotoTransform.currentTranslation = sender.translation(in: self)
////                updateTransforms()
////                return
////            }
////            let oldTransform = storyEditablePhotoItem.editablePhotoTransform.transform
////            storyEditablePhotoItem.editablePhotoTransform.currentTranslation = sender.translation(in: self)
////
////            let frame = photoImageView.frame.applying(oldTransform.inverted()).applying(storyEditablePhotoItem.editablePhotoTransform.transform)
////            let space = 10
////            var currentTranslation: CGPoint {
////                return storyEditablePhotoItem.editablePhotoTransform.currentTranslation
////            }
////
////            if -space...space ~= Int(frame.minX) {
////                if catchedLocationX == nil {
////                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.minX, y: currentTranslation.y)
////                } else if let catchedLocationX = catchedLocationX {
////                    let difference = catchedLocationX - sender.location(in: self).x
////                    if abs(difference) < CGFloat(space) {
////                                            storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.minX, y: currentTranslation.y)
////                    } else {
////                                            storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.minX - difference, y: currentTranslation.y)
////                    }
////                }
////                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
////                if !vibratedX {
////                    catchedLocationX = sender.location(in: self).x
////                    vibratedX = true
////                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
////                }
////            } else if (frame.maxX < (photoContentView.bounds.width + CGFloat(space))) && (frame.maxX > (photoContentView.bounds.width - CGFloat(space))) {
////                if catchedLocationX == nil {
////                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.maxX + photoContentView.bounds.width, y: currentTranslation.y)
////                } else if let catchedLocationX = catchedLocationX {
////                    let difference = catchedLocationX - sender.location(in: self).x
////                    if abs(difference) < CGFloat(space) {
////                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.maxX + photoContentView.bounds.width, y: currentTranslation.y)
////                    } else {
////                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x - frame.maxX + photoContentView.bounds.width - difference, y: currentTranslation.y)
////                    }
////                }
////                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
////                if !vibratedX {
////                    catchedLocationX = sender.location(in: self).x
////                    vibratedX = true
////                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
////                }
////            } else {
////                catchedLocationX = nil
////                vibratedX = false
////            }
////
////            if -space...space ~= Int(frame.minY) {
////                if catchedLocationY == nil {
////                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.minY)
////                } else if let catchedLocationY = catchedLocationY {
////                    let difference = catchedLocationY - sender.location(in: self).y
////                    if abs(difference) < CGFloat(space) {
////                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.minY)
////                    } else {
////                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.minY - difference)
////                    }
////                }
////                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
////                if !vibratedY {
////                    catchedLocationY = sender.location(in: self).y
////                    vibratedY = true
////                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
////                }
////            } else if (frame.maxY < (photoContentView.bounds.height + CGFloat(space))) && (frame.maxY > (photoContentView.bounds.height - CGFloat(space))) {
////                if catchedLocationY == nil {
////                    storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.maxY + photoContentView.bounds.height)
////                } else if let catchedLocationY = catchedLocationY {
////                    let difference = catchedLocationY - sender.location(in: self).y
////                    if abs(difference) < CGFloat(space) {
////                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.maxY + photoContentView.bounds.height)
////                    } else {
////                        storyEditablePhotoItem.editablePhotoTransform.currentTranslation = CGPoint(x: currentTranslation.x, y: currentTranslation.y - frame.maxY + photoContentView.bounds.height - difference)
////                    }
////                }
////                sender.setTranslation(storyEditablePhotoItem.editablePhotoTransform.currentTranslation, in: self)
////                if !vibratedY {
////                    catchedLocationY = sender.location(in: self).y
////                    vibratedY = true
////                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
////                }
////            } else {
////                catchedLocationY = nil
////                vibratedY = false
////            }
////            updateTransforms()
////        default:
////            break
////        }
//    }
//
//    @objc private func rotateGesture(_ sender: UIRotationGestureRecognizer) {
////        switch sender.state {
////        case .began:
////            sender.rotation = storyEditablePhotoItem.editablePhotoTransform.currentRotation
////        case .changed:
////            storyEditablePhotoItem.editablePhotoTransform.currentRotation = sender.rotation
////            updateTransforms()
////        default:
////            break
////        }
//    }
//
//    @objc private func zoomGesture(_ sender: UIPinchGestureRecognizer) {
////        switch sender.state {
////        case .began:
////            sender.scale = storyEditablePhotoItem.editablePhotoTransform.currentScale
////        case .changed:
////            storyEditablePhotoItem.editablePhotoTransform.currentScale = sender.scale
////            updateTransforms()
////        default:
////            break
////        }
//    }
//
//    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
//        guard sender.state == .ended else { return }
//        guard hasPhoto else {
//            delegate?.photoPlaceDidSelected(self) { image in
//                self.storyEditablePhotoItem.update(image: image)
//            }
//            return
//        }
//        _ = becomeFirstResponder()
//    }
//
//    @objc private func doubleTapGesture(_ sender: UITapGestureRecognizer) {
//        //storyEditablePhotoItem.editablePhotoTransform.identity()
//        UIView.animate(withDuration: 0.3) {
//            self.updateTransforms()
//        }
//    }
//
//    @objc private func deletePhoto() {
//        storyEditablePhotoItem.update(image: nil)
//        updateTransforms()
//    }
//
//    // MARK: - Private Functions
//
//    private func setup() {
////        backgroundColor = .clear
////        addSubview(photoContentView)
////        photoContentView.addSubview(photoImageView)
////        addSubview(framePlace)
////        addSubview(deletePhotoButton)
////        layer.addSublayer(dashedLayer)
////
////        storyEditablePhotoItem.image.subscribe(onNext: { [weak self] image in
////            guard let sSelf = self else { return }
////            sSelf.image = image
////            sSelf.photoImageView.image = image
////            if let image = image {
////                _ = sSelf.becomeFirstResponder()
////                sSelf.updateTransforms()
////            } else {
////                _ = sSelf.resignFirstResponder()
////            }
////            self?.updateConstraints()
////            self?.reloadInputViews()
////        }).disposed(by: bag)
////        framePlace.image = storyEditablePhotoItem.photoItem.framePlaceImage
////
////        clipsToBounds = true
////        deletePhotoButton.isHidden = true
////        updateConstraintsIfNeeded()
//    }
//
//    private func setupGestures() {
//        let pan = UIPanGestureRecognizer()
//        photoContentView.addGestureRecognizer(pan)
//        pan.addTarget(self, action: #selector(panGesture(_:)))
//        pan.delegate = self
//
//        let rotation = UIRotationGestureRecognizer()
//        photoContentView.addGestureRecognizer(rotation)
//        rotation.addTarget(self, action: #selector(rotateGesture(_:)))
//        rotation.delegate = self
//
//        let zoom = UIPinchGestureRecognizer()
//        photoContentView.addGestureRecognizer(zoom)
//        zoom.addTarget(self, action: #selector(zoomGesture(_:)))
//        zoom.delegate = self
//
//        let tap = UITapGestureRecognizer()
//        photoContentView.addGestureRecognizer(tap)
//        tap.addTarget(self, action: #selector(tapGesture(_:)))
//        tap.delegate = self
//
//        let doubleTap = UITapGestureRecognizer()
//        photoContentView.addGestureRecognizer(doubleTap)
//        doubleTap.numberOfTapsRequired = 2
//        doubleTap.addTarget(self, action: #selector(doubleTapGesture(_:)))
//        doubleTap.delegate = self
//
//        gestures = [pan, rotation, zoom]
//    }
//
//    private func updateTransforms() {
//        //photoImageView.transform = storyEditablePhotoItem.editablePhotoTransform.transform
//    }
//
//    // MARK: - UIGestureRecognizerDelegate
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return gestures.contains(gestureRecognizer) && gestures.contains(otherGestureRecognizer)
//    }
//
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer is UITapGestureRecognizer {
//            return true
//        }
//        if isFirstResponder {
//            return gestures.contains(gestureRecognizer)
//        } else {
//            return !gestures.contains(gestureRecognizer)
//        }
//    }
//
//    // MARK: - UIResponder
//
//    override func resignFirstResponder() -> Bool {
//        let flag = super.resignFirstResponder()
//        dashedLayer.lineDashPattern = isFirstResponder ? nil : [2, 2]
//        deletePhotoButton.isHidden = !isFirstResponder
//        return flag
//    }
//
//    override func becomeFirstResponder() -> Bool {
//        let flag = super.becomeFirstResponder()
//        dashedLayer.lineDashPattern = isFirstResponder ? nil : [2, 2]
//        deletePhotoButton.isHidden = !isFirstResponder
//        return flag
//    }
//
//}
//
//let queue = DispatchQueue(label: "myImageQueue", qos: .background)
//
//extension PhotoPlace: SliderListener {
//
//    func valueDidChanged(_ value: Float) {
//        DispatchQueue.global(qos: .background).async {
//            self.photoRedactorValue = value
//            guard let imageOpt = ((try? self.storyEditablePhotoItem.image.value()) as UIImage??), let image = imageOpt else {
//                return
//            }
//            if let originalImage = CIImage(image: image) {
//                let outputImage = originalImage.applyingFilter("CISepiaTone",
//                                                               parameters: [
//                                                                kCIInputImageKey: originalImage,
//                                                                kCIInputIntensityKey: Float(Int(value * 100)) / 100,
//                    ])
//                let newImage = UIImage(ciImage: outputImage)
//                DispatchQueue.main.async {
//                    self.photoImageView.image = newImage
//                }
//            }
//        }
//    }
//
//}
