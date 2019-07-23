//
//  BackgroundImageEditModuleController.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

typealias BackgroundPickerListener = BackgroundImagePickerListener & ColorPickerListener

protocol BackgroundImagePickerListener: class {
    func backgroundImageDidChanged(_ imageName: String?)
}

struct BackgroundImage {
    
    static let allImages: [BackgroundImage] = [
        BackgroundImage(imageName: nil, imagePreviewName: "closeButton"),
        BackgroundImage(imageName: "background_1", imagePreviewName: "background_1"),
        BackgroundImage(imageName: "background_2", imagePreviewName: "background_2"),
        BackgroundImage(imageName: "background_3", imagePreviewName: "background_3")
    ]
    
    let imageName: String?
    let imagePreviewName: String
}

/// Контроллер для экрана «ColorEditModule»
final class BackgroundImageEditModuleController: BaseViewController<BackgroundImageEditModulePresentable>, BackgroundImageEditModuleDisplayable, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.registerClass(for: BackgroundImageCell.self)
        return collectionView
    }()
    
    private let images: [BackgroundImage] = BackgroundImage.allImages
    
    // MARK: - Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    // MARK: - BackgroundImageEditModuleDisplayable
    
    // MARK: - Private Functions
    
    // MARK: - Functions

    // MARK: - Actions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: BackgroundImageCell) in
            cell.setup(with: images[indexPath.row].imagePreviewName)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.delegate?.backgroundImageDidChanged(images[indexPath.row].imageName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = round(collectionView.bounds.height * 0.7)
        return CGSize(width: size, height: size)
    }

}

