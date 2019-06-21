//
//  ConstructorSlideView.swift
//  InstaStuff
//
//  Created by aezhov on 14/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class ConstructorSlideView: UIView, UIGestureRecognizerDelegate, ConstructorItemDelegate {
    
    // MARK: - Properties
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "deleteItem"), for: .normal)
        button.addTarget(target, action: #selector(removeItem), for: .touchUpInside)
        return button
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "editItem"), for: .normal)
        button.addTarget(target, action: #selector(editItem), for: .touchUpInside)
        return button
    }()
    
    private lazy var toTopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "moveToBack"), for: .normal)
        button.addTarget(target, action: #selector(itemToTop), for: .touchUpInside)
        return button
    }()
    
    private lazy var toBackgroundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "moveToFront"), for: .normal)
        button.addTarget(target, action: #selector(itemToBackground), for: .touchUpInside)
        return button
    }()
    
    private var editButtons = [UIButton]()
    
    private let contentView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private(set) var items: [UIViewTemplatePlaceble] = []
    
    private(set) var editableView: UIViewTemplatePlaceble? {
        didSet {
            if oldValue == nil {
                editViewPeresenter.endEditing()
            }
            guard oldValue !== editableView else {
                return
            }
            oldValue?.selectAsNotEditable()
            editButtons.forEach { $0.removeFromSuperview() }
            editViewPeresenter.endEditing()
            guard let editableView = editableView else { return }
            editButtons.forEach { addSubview($0) }
            if (editableView is StuffPlace) {
                editButton.removeFromSuperview()
            }
            updateTransforms(for: editableView)
            editViewPeresenter.sliderListener = editableView as? PhotoPlaceConstructor
        }
    }
    
    private let editViewPeresenter: EditViewPresenter
    
    private lazy var customTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapGesture(_:)))
        tap.delegate = self
        return tap
    }()
    
    private var customGestures = [UIGestureRecognizer]()
    
    // MARK: - Construction
    
    init(editViewPeresenter: EditViewPresenter) {
        self.editViewPeresenter = editViewPeresenter
        super.init(frame: .zero)
        editViewPeresenter.slideView = self
        setup()
        addGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        editButtons = [deleteButton, editButton, toTopButton, toBackgroundButton]
        addSubview(contentView)
        contentView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func addGestures() {
        let pan = UIPanGestureRecognizer()
        addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(panGesture(_:)))
        pan.delegate = self
        
        let zoom = UIPinchGestureRecognizer()
        addGestureRecognizer(zoom)
        zoom.addTarget(self, action: #selector(zoomGesture(_:)))
        zoom.delegate = self
        
        let rotation = UIRotationGestureRecognizer()
        addGestureRecognizer(rotation)
        rotation.addTarget(self, action: #selector(rotateGesture(_:)))
        rotation.delegate = self
        
        customGestures = [pan, zoom, customTap, rotation]
        
        addGestureRecognizer(customTap)
    }
    
    private func updateTransforms(for view: UIViewTemplatePlaceble) {
        view.transform = view.storyEditableItem.editableTransform.transform
        let buttonSize: CGFloat = Consts.UIGreed.editButtonsSize
        editButton.frame = CGRect(x: max(-buttonSize, view.frame.minX - buttonSize),
                                    y: max(-buttonSize, view.frame.minY - buttonSize),
                                    width: buttonSize,
                                    height: buttonSize)
        toTopButton.frame = CGRect(x: max(-buttonSize, view.frame.minX - buttonSize),
                                   y: min(bounds.height, view.frame.maxY),
                                   width: buttonSize,
                                   height: buttonSize)
        deleteButton.frame = CGRect(x: min(view.frame.maxX, bounds.maxX),
                                    y: max(-buttonSize, view.frame.minY - buttonSize),
                                    width: buttonSize,
                                    height: buttonSize)
        toBackgroundButton.frame = CGRect(x: min(view.frame.maxX, bounds.maxX),
                                   y: min(bounds.height, view.frame.maxY),
                                   width: buttonSize,
                                   height: buttonSize)
    }
    
    private func view(from sender: UIGestureRecognizer) -> UIViewTemplatePlaceble? {
        return items.filter({ view in
            view.point(inside: contentView.convert(sender.location(in: contentView), to: view), with: nil)
        }).last
    }
    
    private func updateConstratints(_ placebleView: UIViewTemplatePlaceble) {
        let settings = placebleView.storyEditableItem.settings
        placebleView.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview().multipliedBy(settings.center.x * 2.0)
            maker.centerY.equalToSuperview().multipliedBy(settings.center.y * 2.0)
            maker.width.equalToSuperview().multipliedBy(settings.sizeWidth)
            maker.width.equalTo(placebleView.snp.height).multipliedBy(settings.ratio)
        }
    }
    
    // MARK: - Functions
    
    func add(_ placebleView: UIViewTemplatePlaceble) {
        contentView.addSubview(placebleView)
        items.append(placebleView)
        updateConstratints(placebleView)
        if editableView !== placebleView {
            editableView = nil
        }
    }
    
    func updateEditableView() {
        guard let editableView = editableView else { return }
        updateConstratints(editableView)
        layoutIfNeeded()
        updateTransforms(for: editableView)
    }
    
    func setColor(_ value: UIColor) {
        backgroundColor = value
        contentView.backgroundColor = value
    }
    
    func removeSelection() {
        editableView = nil
    }
    
    // MARK: - Actions
    
    private var xD: CGFloat = 0
    
    private var yD: CGFloat = 0
    
    @objc private func zoomGesture(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            guard let item = view(from: sender) else {
                editableView = nil
                return
            }
            editableView = item
            if item is TextViewPlace {
                let A = sender.location(ofTouch: 0, in: editableView)
                let B = sender.location(ofTouch: 1, in: editableView)
                xD = abs( A.x - B.x )
                yD = abs( A.y - B.y )
            } else {
                sender.scale = item.storyEditableItem.editableTransform.currentScale
            }
        case .changed:
            guard let editableView = editableView else { return }
            if editableView is TextViewPlace {
                if sender.numberOfTouches < 2 {
                    return
                }
                let A = sender.location(ofTouch: 0, in: editableView)
                let B = sender.location(ofTouch: 1, in: editableView)
                let xD = abs( A.x - B.x )
                let yD = abs( A.y - B.y )
                let currentWidth = editableView.storyEditableItem.settings.sizeWidth
                let width = currentWidth - ((self.xD - xD) / self.bounds.width)
                let hight = currentWidth / editableView.storyEditableItem.settings.ratio - ((self.yD - yD) / self.bounds.height)
                editableView.storyEditableItem.settings.sizeWidth = width
                editableView.storyEditableItem.settings.ratio = width / hight
                self.xD = xD
                self.yD = yD
                updateConstratints(editableView)
                updateTransforms(for: editableView)
            } else {
                editableView.storyEditableItem.editableTransform.currentScale = sender.scale
                updateTransforms(for: editableView)
            }
        default:
            break
        }
    }
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            guard let item = view(from: sender) else {
                editableView = nil
                return
            }
            editableView = item
            sender.setTranslation(item.storyEditableItem.editableTransform.currentTranslation, in: contentView)
        case .changed:
            guard let editableView = editableView else { return }
            editableView.storyEditableItem.editableTransform.currentTranslation = sender.translation(in: contentView)
            updateTransforms(for: editableView)
        default:
            break
        }
    }
    
    @objc private func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .began:
            guard let item = view(from: sender) else {
                editableView = nil
                return
            }
            editableView = item
            sender.rotation = item.storyEditableItem.editableTransform.currentRotation
        case .changed:
            guard let editableView = editableView else { return }
            editableView.storyEditableItem.editableTransform.currentRotation = sender.rotation
            updateTransforms(for: editableView)
        default:
            break
        }
    }
    
    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        editableView = view(from: sender)
        editableView?.selectAsEditable(delegate: self)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !customGestures.contains(gestureRecognizer), !editViewPeresenter.isEditing {
            return false
        }
        if editViewPeresenter.isEditing, customGestures.contains(gestureRecognizer), gestureRecognizer !== customTap {
            return false
        }
        guard gestureRecognizer === customTap else {
            return true
        }
        return editButtons.first { button -> Bool in
            return button.superview != nil && button.frame.contains(touch.location(in: self))
        } == nil
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.view === otherGestureRecognizer.view
    }
    
    // MARK: - ConstructorItemDelegate
    
    func removeItem() {
        guard let item = editableView else { return }
        item.removeFromSuperview()
        guard let index = items.firstIndex(where: { view in return view === item }) else { return }
        items.remove(at: index)
        editableView = nil
    }
    
    func editItem() {
        if let textView = editableView as? TextViewPlace {
            textView.textView.becomeFirstResponder()
        } else {
            if editViewPeresenter.isEditing {
                editViewPeresenter.endEditing()
            } else {
                editViewPeresenter.beginEdit()
            }
        }
    }
    
    func itemToTop() {
        guard let item = editableView else { return }
        guard let index = items.firstIndex(where: { view in return view === item }) else { return }
        items.remove(at: index)
        items.append(item)
        item.removeFromSuperview()
        contentView.addSubview(item)
        updateConstratints(item)
        updateTransforms(for: item)
    }
    
    func itemToBackground() {
        guard let item = editableView else { return }
        guard let index = items.firstIndex(where: { view in return view === item }) else { return }
        items.remove(at: index)
        items.insert(item, at: 0)
        item.removeFromSuperview()
        contentView.insertSubview(item, at: 0)
        updateConstratints(item)
        updateTransforms(for: item)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return super.point(inside: point, with: event) || editButtons.first(where: { button in
            button.frame.contains(point)
        }) != nil
    }
    
}



