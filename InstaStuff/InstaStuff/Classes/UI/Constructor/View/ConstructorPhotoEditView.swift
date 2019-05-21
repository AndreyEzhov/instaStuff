//
//  ConstructorPhotoEditView.swift
//  InstaStuff
//
//  Created by aezhov on 20/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

private enum Constants {
    static let sectionInset: CGFloat = 10
}


struct PhotoPlaceConstructorSettings {
    let photoItem: PhotoItem
    let settings: Settings
}

class ConstructorPhotoEditView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: Constants.sectionInset, left: Constants.sectionInset, bottom: Constants.sectionInset, right: Constants.sectionInset)
        layout.minimumInteritemSpacing = Constants.sectionInset
        layout.minimumLineSpacing = Constants.sectionInset
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(for: FrameCell.self)
        return collectionView
    }()
    
    private let peresenter: EditViewPeresenter
    
    private let photoItems: [PhotoPlaceConstructorSettings]
    
    // MARK: - Construction
    
    init(peresenter: EditViewPeresenter) {
        self.peresenter = peresenter
        photoItems = [
            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "square", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 1)),
                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 1))
            ,
            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "1_to_2", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 2)),
                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 2)),
            PhotoPlaceConstructorSettings(photoItem: PhotoItem(frameName: "2_to_1", photoAreaLocation: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: 0.5)),
                                          settings: Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.4, angle: 0, ratio: 0.5))
        ]
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - Consts.UIGreed.safeAreaInsetsBottom - 60)
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        addSubview(collectionView)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.bounds.height - 3 * Constants.sectionInset) / 2.0
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: FrameCell) in
            cell.setup(with: photoItems[indexPath.row].photoItem)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        peresenter.modify(with: photoItems[indexPath.row])
    }

}
