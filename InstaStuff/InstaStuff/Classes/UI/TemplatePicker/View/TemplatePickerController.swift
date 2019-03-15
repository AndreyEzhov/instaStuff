//
//  TemplatePickerController.swift
//  InstaStuff
//
//  Created by aezhov on 14/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Контроллер для экрана «TemplatePicker»
final class TemplatePickerController: BaseViewController<TemplatePickerPresentable>, TemplatePickerDisplayable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    /// Есть ли сториборд
    override class var hasStoryboard: Bool { return false }
    
    private lazy var framesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 40, left: 56, bottom: 40, right: 56)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(for: TemplateCollectionViewCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var setsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 24
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 26, left: 20, bottom: 26, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(for: SetCollectionViewCell.self)
        collectionView.backgroundColor = Consts.Colors.applicationColor
        return collectionView
    }()
    
    private var selectedSet: Int = 0
    
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.addSubview(setsCollectionView)
        view.addSubview(framesCollectionView)
        view.updateConstraintsIfNeeded()
        setsCollectionView.selectItem(at: IndexPath(row: selectedSet, section: 0),
                                      animated: false,
                                      scrollPosition: .left)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setsCollectionView.snp.remakeConstraints { maker in
            maker.bottom.left.right.equalToSuperview()
            maker.height.equalTo(100)
        }
        framesCollectionView.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(setsCollectionView.snp.top)
            maker.top.equalTo(view.snp.topMargin)
        }
    }
    
    // MARK: - TemplatePickerDisplayable
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
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
        case setsCollectionView:
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: SetCollectionViewCell) in
                cell.setup(with: presenter.templateSets[indexPath.row])
            })
        case framesCollectionView:
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: TemplateCollectionViewCell) in
                let template = presenter.templateSets[selectedSet].templates[indexPath.row]
                cell.setup(with: template)
                cell.dropShadow()
            })
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        let horisontalInsets = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing
        let width = collectionView.frame.width
        switch collectionView {
        case setsCollectionView:
            return CGSize(width: 48, height: 48)
        case framesCollectionView:
            let cellWidth = (width - horisontalInsets) / 2.0
            return CGSize(width: cellWidth, height: cellWidth * 16.0 / 9.0)
        default:
            return .zero
        }
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch collectionView {
            case setsCollectionView:
                if selectedSet == indexPath.row {
                    return
                }
                selectedSet = indexPath.row
                framesCollectionView.reloadData()
                framesCollectionView.setContentOffset(.zero, animated: false)
            case framesCollectionView:
                let template = presenter.templateSets[selectedSet].templates[indexPath.row]
                navigationController?.router.routeToStoryEditor(parameters: StoryEditorPresenter.Parameters.init(template: template))
            default:
                break
            }
        }
    
}
