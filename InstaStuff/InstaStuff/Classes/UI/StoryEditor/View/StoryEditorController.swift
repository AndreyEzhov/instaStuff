//
//  StoryEditorController.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

final class StoryEditorController: BaseViewController<StoryEditorPresentable>, StoryEditorDisplayable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoPicker {

    // MARK: - Properties
    
    override class var hasStoryboard: Bool { return false }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(for: StorySlideCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var editorView = UIView()
    
    private lazy var setsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 21
        layout.sectionInset = UIEdgeInsets(top: 25, left: 18, bottom: 11, right: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(for: SetCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var framesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(for: TemplateCollectionViewCell.self)
        collectionView.backgroundColor = Consts.Colors.applicationColor
        return collectionView
    }()
    
    private var selectedSet: Int = 0
    
    private var photoDidSelectedBlock: ((UIImage) -> ())?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        collectionView.snp.remakeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(editorView.snp.top)
        }
        editorView.snp.remakeConstraints { maker in
            maker.bottom.left.right.equalToSuperview()
            maker.height.equalTo(160)
        }
        setsCollectionView.snp.remakeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalTo(60)
        }
        framesCollectionView.snp.remakeConstraints { maker in
            maker.bottom.left.right.equalToSuperview()
            maker.top.equalTo(setsCollectionView.snp.bottom)
        }
    }
    
    // MARK: - StoryEditorDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(editorView)
        editorView.addSubview(setsCollectionView)
        editorView.addSubview(framesCollectionView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return presenter.story.slides.count
        case setsCollectionView:
            return presenter.templateSets.count
        case framesCollectionView:
            return selectedSet < presenter.templateSets.count ? presenter.templateSets[selectedSet].templates.count : 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: StorySlideCell) in
                cell.setup(with: presenter.story.slides[indexPath.row])
                cell.photoPlaces.forEach({ photoPlace in
                    (photoPlace as? PhotoPlace)?.delegate = self
                })
            })
        case setsCollectionView:
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: SetCollectionViewCell) in
                cell.setup(with: presenter.templateSets[indexPath.row])
            })
        case framesCollectionView:
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: TemplateCollectionViewCell) in
                let template = presenter.templateSets[selectedSet].templates[indexPath.row]
                cell.setup(with: template)
            })
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            let maxHeight = collectionView.frame.height * 0.9
            let maxWidth = collectionView.frame.width * 0.9
            if maxWidth < maxHeight * Consts.UIGreed.photoRatio {
                return CGSize(width: maxWidth,
                              height: maxWidth / Consts.UIGreed.photoRatio)
            } else {
                return CGSize(width: maxHeight * Consts.UIGreed.photoRatio,
                              height: maxHeight)
            }
        case setsCollectionView:
            return CGSize(width: 60, height: 24)
        case framesCollectionView:
            return CGSize(width: 40, height: 64)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case setsCollectionView:
            selectedSet = indexPath.row
            framesCollectionView.reloadData()
        case framesCollectionView:
            let template = presenter.templateSets[selectedSet].templates[indexPath.row]
            presenter.addSlide(with: template)
            self.collectionView.reloadData()
        default:
            break
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let block = photoDidSelectedBlock {
            block(pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    // MARK: - PhotoPicker
    
    func photoPlaceDidSelected(completion: @escaping (UIImage) -> ()) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        photoDidSelectedBlock = completion
    }
}
