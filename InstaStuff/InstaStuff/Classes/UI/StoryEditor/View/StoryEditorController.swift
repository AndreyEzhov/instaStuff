//
//  StoryEditorController.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

final class StoryEditorController: BaseViewController<StoryEditorPresentable>, StoryEditorDisplayable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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
        layout.minimumLineSpacing = 14
        layout.minimumInteritemSpacing = 11
        layout.sectionInset = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(for: SetCollectionViewCell.self)
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
    }
    
    // MARK: - StoryEditorDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        view.addSubview(collectionView)
        view.addSubview(editorView)
        editorView.addSubview(setsCollectionView)
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
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: StorySlideCell) in
                cell.setup(with: presenter.story.slides[indexPath.row])
            })
        case setsCollectionView:
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: SetCollectionViewCell) in
                cell.setup(with: presenter.templateSets[indexPath.row])
            })
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            let height = collectionView.frame.height * 0.9
            return CGSize(width: height * Consts.UIGreed.photoRatio,
                          height: height)
        case setsCollectionView:
            return CGSize(width: 60, height: 24)
        default:
            return .zero
        }

    }
    
}
