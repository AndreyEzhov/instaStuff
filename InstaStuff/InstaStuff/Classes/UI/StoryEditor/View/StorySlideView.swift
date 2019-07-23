//
//  StorySlideView.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

typealias UIViewTemplatePlaceble = (UIView & TemplatePlaceble)

class StorySlideView: UIView {
    
    // MARK: - Properties
    
    weak var slideViewPresenter: SlideViewPresenter?
    
    private lazy var contentView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "closeButton"), for: .normal)
        button.addTarget(self, action: #selector(deleteSelectedItem), for: .touchUpInside)
        addSubview(button)
        return button
    }()
    
    private lazy var customTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapGesture(_:)))
        tap.delegate = self
        return tap
    }()
    
    private(set) var editableView: UIViewTemplatePlaceble? {
        didSet {
            slideViewPresenter?.selectedItem = editableView
            closeButton.isHidden = editableView == nil
            //            if oldValue == nil {
            //                editViewPeresenter.endEditing()
            //            }
            //            guard oldValue !== editableView else {
            //                return
            //            }
            //            oldValue?.selectAsNotEditable()
            //            editButtons.forEach { $0.removeFromSuperview() }
            //            editViewPeresenter.endEditing()
            //            guard let editableView = editableView else { return }
            //            editButtons.forEach { addSubview($0) }
            //            if (editableView is StuffPlace) {
            //                editButton.removeFromSuperview()
            //            }
            //            updateTransforms(for: editableView)
            //            editViewPeresenter.sliderListener = editableView as? PhotoPlaceConstructor
        }
    }
    
    private var customGestures = [UIGestureRecognizer]()
    
    // MARK: - Construction
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    func removeAllItems() {
        contentView.image = nil
        contentView.backgroundColor = UIColor.white
        contentView.subviews.forEach { view in
            view.removeFromSuperview()
        }
    }
    
    func setBackgroundImage(_ image: UIImage?) {
        contentView.image = image
    }
    
    func setBackgroundColor(_ color: UIColor?) {
        contentView.backgroundColor = color
    }
    
    func addGestures() {
        let pan = UIPanGestureRecognizer()
        contentView.addGestureRecognizer(pan)
        pan.addTarget(self, action: #selector(panGesture(_:)))
        pan.delegate = self
        
        let rotation = UIRotationGestureRecognizer()
        contentView.addGestureRecognizer(rotation)
        rotation.addTarget(self, action: #selector(rotateGesture(_:)))
        rotation.delegate = self
        
        let zoom = UIPinchGestureRecognizer()
        contentView.addGestureRecognizer(zoom)
        zoom.addTarget(self, action: #selector(zoomGesture(_:)))
        zoom.delegate = self
        
        contentView.addGestureRecognizer(customTap)
        
        customGestures = [pan, zoom, customTap, rotation]
    }
    
    func placeSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
    
    func sendItemToBack(_ view: UIView) {
        contentView.sendSubviewToBack(view)
    }
    
    func bringItemToFront(_ view: UIView) {
        contentView.bringSubviewToFront(view)
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        backgroundColor = .white
        addSubview(contentView)
        contentView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func view(from sender: UIGestureRecognizer) -> UIViewTemplatePlaceble? {
        return contentView.subviews.filter { $0 is UIViewTemplatePlaceble }.filter({ view in
            view.point(inside: convert(sender.location(in: self), to: view), with: nil)
        }).last as? UIViewTemplatePlaceble
    }
    
    private func updateDeleteButton() {
        if let editableView = editableView {
            let x = min(max(0, editableView.frame.maxX), bounds.width - 40)
            let y = min(max(0, editableView.frame.minY - 40), bounds.height - 40)
            closeButton.frame = CGRect(x: x, y: y, width: 40, height: 40)
        }
    }
    
    // MARK: - ColorPickerLostener
    
    //    func colorDidChanged(_ value: UIColor) {
    //        backgroundColor = value
    //        slide.template.backgroundColor = value
    //    }
    //
    //    func checkMarkTouch() {
    //        resignFirstResponder()
    //    }
    //
    //    func placePipette(completion: @escaping (UIColor?) -> ()) {
    //        pippeteDelegate?.placePipette(completion: completion)
    //    }
    
    // MARK: - Actions
    
    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        editableView = view(from: sender)
        updateDeleteButton()
    }
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        guard let slideViewPresenter = slideViewPresenter else { return }
        switch sender.state {
        case .began:
            guard let item = view(from: sender) else {
                editableView = nil
                return
            }
            editableView = item
            let center = item.storyEditableItem.settings.center
            let currentTranslation = CGPoint(x: center.x * bounds.width, y: center.y * bounds.height)
            sender.setTranslation(currentTranslation, in: self)
        case .changed:
            var translation = sender.translation(in: self)
            translation = CGPoint(x: translation.x / bounds.width, y: translation.y / bounds.height)
            slideViewPresenter.apply(translation: translation)
            updateDeleteButton()
        default:
            break
        }
    }
    
    @objc private func rotateGesture(_ sender: UIRotationGestureRecognizer) {
        guard let slideViewPresenter = slideViewPresenter else { return }
        switch sender.state {
        case .began:
            guard let item = view(from: sender) else {
                editableView = nil
                return
            }
            editableView = item
            sender.rotation = item.storyEditableItem.settings.angle
        case .changed:
            slideViewPresenter.apply(rotation: sender.rotation)
            updateDeleteButton()
        default:
            break
        }
    }
    
    @objc private func zoomGesture(_ sender: UIPinchGestureRecognizer) {
        guard let slideViewPresenter = slideViewPresenter else { return }
        switch sender.state {
        case .began:
            guard let item = view(from: sender) else {
                editableView = nil
                return
            }
            editableView = item
            sender.scale = item.storyEditableItem.settings.sizeWidth
        case .changed:
            slideViewPresenter.apply(scale: sender.scale)
            updateDeleteButton() 
        default:
            break
        }
    }
    
    @objc private func deleteSelectedItem() {
        guard let view = editableView else { return }
        editableView = nil
        view.removeFromSuperview()
        slideViewPresenter?.deleteItem(view)
    }
    
    
}

extension StorySlideView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.view === otherGestureRecognizer.view
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //        if !customGestures.contains(gestureRecognizer) {
        //            return false
        //        }
        //        if customGestures.contains(gestureRecognizer), gestureRecognizer !== customTap {
        //            return false
        //        }
        //        guard gestureRecognizer === customTap else {
        //            return true
        //        }
        return true
    }
}
