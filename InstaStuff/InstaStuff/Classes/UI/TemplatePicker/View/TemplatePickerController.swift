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
    
    private lazy var framesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 40, left: 30, bottom: 40, right: 30)
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
    
    private lazy var addNewTemplateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "bigPlus"), for: .normal)
        button.addTarget(self, action: #selector(addNewTemplateTouch), for: .touchUpInside)
        return button
    }()
    
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
        view.addSubview(addNewTemplateButton)
        addNewTemplateButton.isHidden = !presenter.usersTemplate
        setsCollectionView.isHidden = presenter.usersTemplate
        view.updateConstraintsIfNeeded()
        if setsCollectionView.numberOfItems(inSection: 0) > presenter.selectedSet {
            setsCollectionView.selectItem(at: IndexPath(row: presenter.selectedSet, section: 0),
                                          animated: false,
                                          scrollPosition: .left)
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setsCollectionView.snp.remakeConstraints { maker in
            maker.bottom.left.right.equalToSuperview()
            maker.height.equalTo(100 + Consts.UIGreed.safeAreaInsetsBottom)
        }
        addNewTemplateButton.snp.remakeConstraints { maker in
            maker.bottom.left.right.equalToSuperview()
            maker.height.equalTo(100 + Consts.UIGreed.safeAreaInsetsBottom)
        }
        framesCollectionView.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(setsCollectionView.snp.top)
            maker.top.equalTo(view.snp.topMargin)
        }
    }
    
    // MARK: - TemplatePickerDisplayable
    
    func updateCollectionView() {
        framesCollectionView.reloadData()
    }
    
    // MARK: - Private Functions
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    @objc private func addNewTemplateTouch() {
        navigationController?.router.routeToStoryPicker()
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case setsCollectionView:
            return presenter.templateSets.count
        case framesCollectionView:
            return presenter.templates.count
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
                let template = presenter.templates[indexPath.row]
                cell.setup(with: presenter.imageHandler.loadImage(named: template.name),
                           delegate: presenter.usersTemplate ? self : nil,
                           template: template)
                cell.dropShadow()
            })
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case setsCollectionView:
            return CGSize(width: 48, height: 48)
        case framesCollectionView:
            return CGSize(width: 140, height: 140.0 / Consts.UIGreed.photoRatio)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case setsCollectionView:
            if presenter.selectedSet == indexPath.row {
                return
            }
            presenter.selectSet(at: indexPath.row)
            framesCollectionView.reloadData()
            framesCollectionView.setContentOffset(.zero, animated: false)
        case framesCollectionView:
            let template = presenter.templates[indexPath.row]
            navigationController?.router.routeToStoryEditor(parameters: StoryEditorPresenter.Parameters.init(template: template))
        default:
            break
        }
    }
    
}


extension TemplatePickerController: StoryRemoveDelegate {
    
    func deleteTemplate(_ template: Template?) {
        guard let template = template else { return }
        guard let index = presenter.deleteTemplate(template) else { return }
        framesCollectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
}
