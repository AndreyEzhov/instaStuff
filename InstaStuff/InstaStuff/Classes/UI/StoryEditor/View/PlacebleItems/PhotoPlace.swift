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
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var photoPlace: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var framePlace: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var photoContentFrameView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 3
        view.isUserInteractionEnabled = false
        return view
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
    
    override var inputView: UIView? {
        if hasPhoto {
            let view = Assembly.shared.createPhotoModuleControllerController(params: PhotoModuleControllerPresenter.Parameters())
            view.delegate = self
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
            return view
        } else {
            return nil
        }
    }
    
    private let bag = DisposeBag()
    
    weak var delegate: PhotoPicker?
    
    private var gestures: [UIGestureRecognizer] = []
    
    private var hasPhoto: Bool {
        if let image = try? storyEditablePhotoItem.image.value(), image == nil {
            return false
        }
        return true
    }
    
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
    
    override func updateConstraints() {
        super.updateConstraints()
        photoContentView.snp.remakeConstraints { maker in
            let settings = storyEditablePhotoItem.photoItem.photoAreaLocation
            maker.width.equalTo(photoContentView.snp.height).multipliedBy(settings.ratio)
            maker.width.equalToSuperview().multipliedBy(settings.sizeWidth)
            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2)
            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2)
        }
        photoPlace.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        photoImageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        framePlace.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        photoContentFrameView.snp.remakeConstraints { maker in
            maker.edges.equalTo(photoContentView.snp.edges)
        }
        deletePhotoButton.snp.remakeConstraints { maker in
            maker.top.equalTo(photoContentFrameView.snp.top)
            maker.right.equalTo(photoContentFrameView.snp.right)
            maker.size.equalTo(CGSize(width: 30, height: 30))
        }
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
            storyEditablePhotoItem.editablePhotoTransform.currentScale = sender.scale
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
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        addSubview(photoPlace)
        addSubview(photoContentView)
        photoContentView.addSubview(photoImageView)
        addSubview(framePlace)
        addSubview(photoContentFrameView)
        addSubview(deletePhotoButton)
        
        photoPlace.image = storyEditablePhotoItem.photoItem.photoPlaceImage
        storyEditablePhotoItem.image.subscribe(onNext: { [weak self] image in
            self?.photoImageView.image = image
            if image == nil {
                _ = self?.resignFirstResponder()
            } else {
                _ = self?.becomeFirstResponder()
            }
            self?.reloadInputViews()
        }).disposed(by: bag)
        framePlace.image = storyEditablePhotoItem.photoItem.framePlaceImage
        
        clipsToBounds = true
        photoContentFrameView.isHidden = true
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
        photoContentFrameView.isHidden = !isFirstResponder
        deletePhotoButton.isHidden = !isFirstResponder
        return flag
    }
    
    override func becomeFirstResponder() -> Bool {
        let flag = super.becomeFirstResponder()
        photoContentFrameView.isHidden = !isFirstResponder
        deletePhotoButton.isHidden = !isFirstResponder
        return flag
    }
    
}

let queue = DispatchQueue(label: "myImageQueue", qos: .background)

extension PhotoPlace: SliderListener {
    
    func valueDidChanged(_ value: Float) {
        DispatchQueue.global(qos: .background).async {
            guard let imageOpt = try? self.storyEditablePhotoItem.image.value(), let image = imageOpt else {
                return
            }
            if let originalImage = CIImage(image: image) {
                let outputImage = originalImage.applyingFilter("CIColorControls",
                                                               parameters: [
                                                                kCIInputImageKey: originalImage,
                                                                kCIInputSaturationKey: 1.0 - 0.05 * value,
                                                                kCIInputContrastKey: 1.0 - 0.05 * value,
                                                                kCIInputBrightnessKey: 0.05 * value,
                                                                ])
                let newImage = UIImage(ciImage: outputImage)
                DispatchQueue.main.async {
                    self.photoImageView.image = newImage
                }
            }
        }
    }
    
}
