//
//  StorySlideView.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

typealias UIViewTemplatePlaceble = (UIView & TemplatePlaceble)

class StorySlideView: UIView, ColorPickerLostener {
    
    // MARK: - Properties
    
    private let backgroundImageView =  UIImageView()
    
    private var slide: StoryItem
    
    private(set) var photoPlaces: [UIViewTemplatePlaceble] = []
    
    override var inputView: UIView? {
        let view = Assembly.shared.createBackgroundModuleControllerController(params: BackgroundModuleControllerPresenter.Parameters(colorPickerModule: colorPickerModule))
        view.delegate = self
        return view
    }
    
    private let colorPickerModule = ColorPickerModule()
    
    override var canBecomeFirstResponder: Bool {
        return _canBecomeFirstResponder
    }
    
    private var _canBecomeFirstResponder = false
    
    // MARK: - Construction
    
    init(slide: StoryItem) {
        self.slide = slide
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        super.updateConstraints()
        backgroundImageView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        photoPlaces.enumerated().forEach { arg in
            let (offset, place) = arg
            let frameArea = slide.template.frameAreas[offset]
            place.snp.remakeConstraints { maker in
                maker.centerX.equalToSuperview().multipliedBy(frameArea.settings.center.x * 2.0)
                maker.centerY.equalToSuperview().multipliedBy(frameArea.settings.center.y * 2.0)
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
    
    private func setup() {
        setupTap()
        clipsToBounds = true
        subviews.forEach { view in
            view.removeFromSuperview()
        }
        photoPlaces.removeAll()
        addSubview(backgroundImageView)
        slide.items.enumerated().forEach { arg in
            var view: UIViewTemplatePlaceble?
            switch arg.element {
            case let item as StoryEditablePhotoItem:
                view = PhotoPlace(item)
            case let item as StoryEditableTextItem:
                view = TextViewPlace(item)
            case let item as StoryEditableStuffItem:
                view = StuffPlace(item)
            case let item as StoryEditableViewItem:
                view = ViewPlace(item)
            default:
                break
            }
            if let view = view {
                photoPlaces.append(view)
                view.tag = arg.offset
                addSubview(view)
            }
        }
        backgroundImageView.image = slide.template.backgroundImage
        setNeedsUpdateConstraints()
    }
    
    private func setupTap() {
        let tap = UITapGestureRecognizer()
        addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(editSlideBackground(_:)))
    }
    
    // MARK: - Actions
    
    @objc private func editSlideBackground(_ sender: UITapGestureRecognizer) {
        _canBecomeFirstResponder = true
        _ = isFirstResponder ? resignFirstResponder() : becomeFirstResponder()
        _canBecomeFirstResponder = false
    }
    
    // MARK: - ColorPickerLostener
    
    func colorDidChanged(_ value: UIColor) {
        backgroundColor = value
        slide.template.backgroundColor = value
    }
    
    func checkMarkTouch() {
        resignFirstResponder()
    }
    
    func placePipette(completion: @escaping (UIColor?) -> ()) {
        
    }
}
