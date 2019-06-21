//
//  ItemEditModuleController.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol PreviewProtocol {
    var preview: UIImage? { get }
}

private enum Constants {
    static let sectionInset: CGFloat = 10
}

/// Контроллер для экрана «ItemEditModule»
final class ItemEditModuleController: BaseViewController<ItemEditModulePresentable>, ItemEditModuleDisplayable, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - Properties

    /// Есть ли сториборд
    override class var hasStoryboard: Bool { return false }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.sectionInset, bottom: 0, right: Constants.sectionInset)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(for: FrameCell.self)
        return collectionView
    }()

    // MARK: - Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(collectionView)
    }
    
    // MARK: - ItemEditModuleDisplayable
    
    // MARK: - Private Functions
    
    // MARK: - Functions

    // MARK: - Actions
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height / CGFloat(presenter.numberOfRows)
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
