//
//  StoryPickerController.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import SnapKit

final class StoryPickerController: BaseViewController<StoryPickerPresentable>, StoryPickerDisplayable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    override class var hasStoryboard: Bool { return false }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsets(top: 21, left: 18, bottom: 21, right: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(for: CreateStoryCell.self)
        collectionView.registerClass(for: StoryCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        collectionView.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    // MARK: - StoryPickerDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        view.addSubview(collectionView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + presenter.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row == 0 else {
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: StoryCell) in
                let story = presenter.stories[indexPath.row - 1]
                cell.setup(with: story) {
                    if let index = self.presenter.stories.firstIndex(where: { $0 == story }) {
                        self.presenter.deleteStory(at: index)
                        collectionView.deleteItems(at: [IndexPath(row: index + 1, section: 0)])
                    }
                }
            })
        }
        return collectionView.dequeue(indexPath: indexPath, with: { (_: CreateStoryCell) in })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var story: StoryItem
        if indexPath.row == 0 {
            story = presenter.createNewStory()
            collectionView.insertItems(at: [IndexPath(row: 1, section: 0)])
        } else {
            story = presenter.stories[indexPath.row-1]
        }
        navigationController?.router.routeToStoryEditor(parameters: StoryEditorPresenter.Parameters(story: story))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let width = (collectionView.frame.width - layout.sectionInset.left - layout.sectionInset.right - layout.minimumInteritemSpacing) / 2.0
        return CGSize(width: width, height: width)
    }
    
}
