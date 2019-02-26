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
    
    // MARK: - StoryEditorDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        view.addSubview(collectionView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions

    // MARK: - Actions
    
    @objc private func addSlide() {
        presenter.addSlide(at: 0)
    }

    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: StorySlideCell) in
            let areas = [
                UIBezierPath(rect: CGRect(x: 0, y: 0, width: Consts.UIGreed.photoRatio, height: 1)),
                UIBezierPath(ovalIn: CGRect(x: 0.3, y: 0.3, width: 0.4, height: 0.4))
            ]
            let template = FrameTemplate(id: 0, name: "TEST", photoAreas: areas)
            let storySlide = StorySlide(template: template)
            cell.setup(with: storySlide)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height * 0.9
        return CGSize(width: height * Consts.UIGreed.photoRatio,
                      height: height)
    }
    
}
