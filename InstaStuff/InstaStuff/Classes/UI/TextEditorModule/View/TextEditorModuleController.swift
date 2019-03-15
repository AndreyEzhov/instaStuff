//
//  TextEditorModuleController.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Контроллер для экрана «TextEditorModule»
final class TextEditorModuleController: UIView, TextEditorModuleDisplayable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    private var presenter: TextEditorModulePresentable!
    
    /// Есть ли сториборд
    class func controller(presenter: TextEditorModulePresentable) -> TextEditorModuleController {
        let view = TextEditorModuleController(frame: .zero)
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    private lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.registerClass(for: TextEditableItemCell.self)
        return collectionView
    }()
    
    // MARK: - Construction
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        itemsCollectionView.snp.remakeConstraints { maker in
            maker.top.left.right.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(0.7)
        }
        super.updateConstraints()
    }
    
    // MARK: - TextEditorModuleDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        addSubview(itemsCollectionView)
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.editableItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: TextEditableItemCell) in
            cell.setup(with: presenter.editableItems[indexPath.row])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let countInARow = presenter.editableItems.count / 2
        let verticalInsets = layout.sectionInset.top + layout.sectionInset.bottom + layout.minimumLineSpacing
        let horisontalInsets = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing * CGFloat(countInARow - 1)
        let collectionViewSize = collectionView.frame.size
        let width = floorf(Float((collectionViewSize.width - horisontalInsets) / CGFloat(countInARow)))
        let height = floorf(Float((collectionViewSize.height - verticalInsets) / 2.0))
        return CGSize(width: CGFloat(width),
                      height: CGFloat(height))
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
