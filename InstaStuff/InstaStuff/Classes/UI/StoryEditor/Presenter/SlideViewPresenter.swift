//
//  SlideViewPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 05/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

class SlideViewPresenter {
    
    // MARK: - Properties
    
    private let storySlideView: StorySlideView
    
    private let storyItem: StoryItem
    
    private let editorPresenter: EditorPresenter
    
    var selectedItem: UIViewTemplatePlaceble? {
        didSet {
            guard oldValue !== selectedItem else {
                return
            }
            if selectedItem == nil {
                editorPresenter.defaultState()
                return
            }
            editorPresenter.update(with: .stuffEdit(self))
        }
    }
    
    // MARK: - Construction
    
    init(storySlideView: StorySlideView, storyItem: StoryItem, editorPresenter: EditorPresenter) {
        self.storySlideView = storySlideView
        self.storyItem = storyItem
        self.editorPresenter = editorPresenter
        storySlideView.slideViewPresenter = self
        editorPresenter.slideViewPresenter = self
        
        replaceAllElemets()
    }
    
    // MARK: - Private Functions
    
    private func replaceAllElemets() {
        storySlideView.removeAllItems()
        storySlideView.setBackgroundImage(storyItem.backgroundImage)
        storySlideView.backgroundColor = storyItem.backgroundColor
        
        storyItem.items.forEach { item in
            self.placeElement(item)
        }
    }
    
    private func updateTransform(for view: UIViewTemplatePlaceble) {
        var transform = CGAffineTransform.identity
        transform = transform.rotated(by: view.storyEditableItem.settings.angle)
        view.transform = transform
    }
    
    private func placeElement(_ item: StoryEditableItem) {
        var view: UIViewTemplatePlaceble?
        switch item {
            //            case let item as StoryEditablePhotoItem:
            //                view = PhotoPlace(item)
            //            case let item as StoryEditableTextItem:
        //                view = TextViewPlace(item)
        case let item as StoryEditableStuffItem:
            let stuffPlace = StuffPlace(item)
            view = stuffPlace
            //            case let item as StoryEditableViewItem:
        //                view = ViewPlace(item)
        default:
            break
        }
        guard let viewTemplatePlaceble = view else { return }
        storySlideView.placeSubview(viewTemplatePlaceble)
        updatePosition(for: viewTemplatePlaceble)
    }
    
    private func updatePosition(for view: UIViewTemplatePlaceble) {
        var ratio: CGFloat?
        let item = view.storyEditableItem
        switch item {
        case let stuffPlace as StoryEditableStuffItem:
            ratio = stuffPlace.ratio
        default:
            break
        }
        guard let viewRatio = ratio else { return }
        view.snp.remakeConstraints({ maker in
            maker.centerX.equalToSuperview().multipliedBy(item.settings.center.x * 2.0)
            maker.centerY.equalToSuperview().multipliedBy(item.settings.center.y * 2.0)
            maker.width.equalToSuperview().multipliedBy(item.settings.sizeWidth)
            maker.width.equalTo(view.snp.height).multipliedBy(viewRatio)
        })
        updateTransform(for: view)
    }
    
    // MARK: - Functions
    
    func add(_ item: StoryEditableItem) {
        storyItem.items.append(item)
        placeElement(item)
    }
    
    func apply(translation: CGPoint) {
        guard let selectedItem = selectedItem else { return }
        selectedItem.storyEditableItem.settings.center = translation
        updatePosition(for: selectedItem)
    }
    
    func apply(rotation: CGFloat) {
        guard let selectedItem = selectedItem else { return }
        selectedItem.storyEditableItem.settings.angle = rotation
        updateTransform(for: selectedItem)
    }
    
    func apply(scale: CGFloat) {
        guard let selectedItem = selectedItem else { return }
        selectedItem.storyEditableItem.settings.sizeWidth = scale
        updatePosition(for: selectedItem)
    }
    
    func deleteItem(_ item: UIViewTemplatePlaceble) {
        let item = item.storyEditableItem
        storyItem.items.removeAll { $0 === item }
    }
}

extension SlideViewPresenter: BaseEditProtocol {
    func moveToFront() {
        guard let selectedItem = selectedItem else { return }
        let item = selectedItem.storyEditableItem
        storyItem.items.removeAll { $0 === item }
        storyItem.items.append(item)
        storySlideView.bringItemToFront(selectedItem)
    }
    
    func moveToBack() {
        guard let selectedItem = selectedItem else { return }
        let item = selectedItem.storyEditableItem
        storyItem.items.removeAll { $0 === item }
        storyItem.items.insert(item, at: 0)
        storySlideView.sendItemToBack(selectedItem)
    }
    
    
}
