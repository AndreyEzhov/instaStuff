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


struct PhotoPlaceConstructorSettings: PreviewProtocol {
    let photoItem: PhotoItem
    let settings: Settings
    var preview: UIImage? {
        return photoItem.preview
    }
}

protocol PreviewProtocol {
    var preview: UIImage? { get }
}

protocol CunstructorEditViewProtocol {
    var dataSource: [PreviewProtocol] { get }
    func select(at index: Int)
    func beginEdit()
    func endEditing()
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
    
    var presenter: CunstructorEditViewProtocol {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Construction
    
    init(presenter: CunstructorEditViewProtocol) {
        self.presenter = presenter
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
        return presenter.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: FrameCell) in
            cell.setup(with: presenter.dataSource[indexPath.row].preview)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.select(at: indexPath.row)
    }

}
