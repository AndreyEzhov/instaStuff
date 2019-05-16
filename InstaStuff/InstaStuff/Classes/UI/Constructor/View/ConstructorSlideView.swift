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
    
    private let contentView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private var items: [UIViewTemplatePlaceble] = []
    
    private var editableView: UIViewTemplatePlaceble? {
        didSet {
            guard oldValue !== editableView else {
                return
            }
            oldValue?.selectAsNotEditable()
            editView.removeFromSuperview()
            guard let editableView = editableView else { return }
            addSubview(editView)
            updateTransforms(for: editableView)
        }
    }
    
    private var editView: EditView = {
        let view = EditView()
        return view
    }()
    
    private lazy var customTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapGesture(_:)))
        tap.delegate = self
        return tap
    }()
    
    // MARK: - Construction
    
    init() {
        super.init(frame: .zero)
        setup()
        addGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        editView.setup(target: self)
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
        
        addGestureRecognizer(customTap)
    }
    
    private func updateTransforms(for view: UIViewTemplatePlaceble) {
        view.transform = view.storyEditableItem.editableTransform.transform
        guard let superview = superview else { return }
        let origin = CGPoint(x: max(-30, view.frame.minX - 30),
                             y: max(-30, view.frame.minY - 30))
        let originRight = CGPoint(x: min(bounds.width + 30, view.frame.maxX + 30),
                                  y: min(bounds.height + 30, view.frame.maxY + 30))
        editView.frame = CGRect(origin: origin,
                                size: CGSize(width: originRight.x - origin.x,
                                             height: originRight.y - origin.y))
    }
    
    private func view(from sender: UIGestureRecognizer) -> UIViewTemplatePlaceble? {
        return items.filter({ view in view.frame.contains(sender.location(in: contentView)) }).last
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
    }
    
    // MARK: - Actions
    
    @objc private func zoomGesture(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .began:
            guard let item = view(from: sender) else {
                editableView = nil
                return
            }
            editableView = item
            sender.scale = item.storyEditableItem.editableTransform.currentScale
        case .changed:
            guard let editableView = editableView else { return }
            editableView.storyEditableItem.editableTransform.currentScale = sender.scale
            updateTransforms(for: editableView)
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
    
    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        editableView = view(from: sender)
        editableView?.selectAsEditable(delegate: self)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard gestureRecognizer === customTap else {
            return true
        }
        guard let superview = editView.superview else {
            return true
        }
        return editView.subviews.first { button -> Bool in
            return editView.convert(button.frame, to: self).contains(touch.location(in: self))
        } == nil
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
        return editView.frame.contains(point) || super.point(inside: point, with: event)
    }
    
    
}
