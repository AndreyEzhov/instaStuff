//
//  SlideViewPresenter.swift
//  InstaStuff
//
//  Created by aezhov on 05/07/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SlideViewPresenter {
    
    // MARK: - Properties
    
    let storySlideView: StorySlideView
    
    private let storyItem: StoryItem
    
    private let editorPresenter: EditorPresenter
    
    private let coef: CGFloat
    
    private weak var photoPicker: PhotoPickerProtocol?
    
    private let imageHandler: ImageHandler
    
    private let bag = DisposeBag()
    
    private(set) var isPhotoLocked = false
    
    // MARK: - Construction
    
    init(storySlideView: StorySlideView, storyItem: StoryItem, editorPresenter: EditorPresenter, coef: CGFloat, photoPicker: PhotoPickerProtocol, imageHandler: ImageHandler) {
        self.photoPicker = photoPicker
        self.coef = coef
        self.storySlideView = storySlideView
        self.storyItem = storyItem
        self.editorPresenter = editorPresenter
        self.imageHandler = imageHandler
        editorPresenter.slideViewPresenter = self
        storySlideView.slideViewPresenter = self
        setup()
        replaceAllElemets()
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        TextViewPlace.editView.presenter.baseEditor = self
        storySlideView
            .editableView
            .distinctUntilChanged { (oldView, newView) -> Bool in
                return oldView === newView
            }
            .subscribe(onNext: { [weak self] view in
                guard let sSelf = self else { return }
                sSelf.isPhotoLocked = false
                if view is StuffPlace {
                    sSelf.editorPresenter.update(with: .stuffEdit(sSelf))
                } else if view is PhotoPlace {
                    sSelf.editorPresenter.update(with: .addPhotoFrame(sSelf))
                } else {
                    sSelf.editorPresenter.defaultState()
                }
            })
            .disposed(by: bag)
    }
    
    private func replaceAllElemets() {
        storySlideView.removeAllItems()
        storySlideView.setBackgroundImage(storyItem.backgroundImage)
        storySlideView.setBackgroundColor(storyItem.backgroundColor)
        
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
        case let item as StoryEditablePhotoItem:
            let photoPlace = PhotoPlace(item, imageHandler: imageHandler)
            view = photoPlace
            photoPlace.pickImageTapGesture.rx.event.subscribe(onNext: { [weak self] gesture in
                if gesture.state == .ended {
                    self?.photoPicker?.photoPlaceDidSelected(completion: { image in
                        self?.imageHandler.deleteImage(named: item.imageName.value)
                        let uuid = UUID().uuidString
                        self?.imageHandler.saveImage(image, name: uuid)
                        item.update(imageName: uuid)
                    })
                }
            }).disposed(by: bag)
        case let item as StoryEditableStuffItem:
            let stuffPlace = StuffPlace(item)
            view = stuffPlace
        case let item as StoryEditableTextItem:
            let textPlace = TextViewPlace(item, coef: CFloat(coef))
            view = textPlace
        default:
            break
        }
        guard let viewTemplatePlaceble = view else { return }
        storySlideView.placeSubview(viewTemplatePlaceble)
        updatePosition(for: viewTemplatePlaceble)
    }
    
    private func updatePosition(for view: UIViewTemplatePlaceble) {
        let item = view.storyEditableItem
        guard let viewRatio = item.ratio else { return }
        view.snp.remakeConstraints({ maker in
            maker.centerX.equalToSuperview().multipliedBy(item.settings.center.x * 2.0)
            maker.centerY.equalToSuperview().multipliedBy(item.settings.center.y * 2.0)
            maker.width.equalToSuperview().multipliedBy(item.settings.sizeWidth)
            maker.width.equalTo(view.snp.height).multipliedBy(viewRatio)
        })
        updateTransform(for: view)
    }
    
    private func updatePhotoInFramePosition(for view: PhotoPlace) {
        view.updateConstraints()
    }
    
    private func setupBackgroundColor(_ color: UIColor?) {
        let color = color ?? .white
        storyItem.backgroundColor = color
        storySlideView.setBackgroundColor(color)
    }
    
    private func setupBackgroundImage(_ imageName: String?) {
        storyItem.backgroundImageName = imageName
        storySlideView.setBackgroundImage(storyItem.backgroundImage)
    }
    
    // MARK: - Functions
    
    func addOrModify(_ item: PhotoItem) {
        if let selectedFrame = storySlideView.editableView.value as? PhotoPlace {
            selectedFrame.update(with: item)
            updatePosition(for: selectedFrame)
            storySlideView.layoutIfNeeded()
            storySlideView.updateDeleteButton()
        } else {
            let settings = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.7, angle: 0)
            add(StoryEditablePhotoItem(item, customSettings: nil, settings: settings, dafultImageName: nil))
        }
    }
    
    func add(_ item: StoryEditableItem) {
        storyItem.items.append(item)
        placeElement(item)
    }
    
    func setBackgroundColor(_ color: UIColor?) {
        setupBackgroundColor(color)
        setupBackgroundImage(nil)
    }
    
    func setBackgroundImage(_ imageName: String?) {
        setupBackgroundColor(.white)
        setupBackgroundImage(imageName)
    }
    
    func apply(translation: CGPoint) {
        guard let selectedItem = storySlideView.editableView.value else { return }
        if isPhotoLocked, let photoPlace = selectedItem as? PhotoPlace {
            photoPlace.storyEditablePhotoItem.photoItem.photoPositionSettings.center = translation
            updatePhotoInFramePosition(for: photoPlace)
        } else {
            selectedItem.storyEditableItem.settings.center = translation
            updatePosition(for: selectedItem)
        }
    }
    
    func apply(rotation: CGFloat) {
        guard let selectedItem = storySlideView.editableView.value else { return }
        selectedItem.storyEditableItem.settings.angle = rotation
        updateTransform(for: selectedItem)
    }
    
    func apply(scale: CGFloat) {
        guard let selectedItem = storySlideView.editableView.value else { return }
        selectedItem.storyEditableItem.settings.sizeWidth = scale
        updatePosition(for: selectedItem)
    }
    
    func deleteItem(_ item: UIViewTemplatePlaceble) {
        let item = item.storyEditableItem
        if let photoItem = item as? StoryEditablePhotoItem {
            imageHandler.deleteImage(named: photoItem.imageName.value)
        }
        storyItem.items.removeAll { $0 === item }
    }
}

extension SlideViewPresenter: BaseEditProtocol {
    
    func lock(_ sender: UIButton) {
        isPhotoLocked.toggle()
        sender.isSelected = isPhotoLocked
    }
    
    func moveToFront() {
        guard let selectedItem = storySlideView.editableView.value else { return }
        let item = selectedItem.storyEditableItem
        storyItem.items.removeAll { $0 === item }
        storyItem.items.append(item)
        storySlideView.bringItemToFront(selectedItem)
    }
    
    func moveToBack() {
        guard let selectedItem = storySlideView.editableView.value else { return }
        let item = selectedItem.storyEditableItem
        storyItem.items.removeAll { $0 === item }
        storyItem.items.insert(item, at: 0)
        storySlideView.sendItemToBack(selectedItem)
    }
    
    
}
