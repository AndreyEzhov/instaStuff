//
//  ColorEditModuleController.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Контроллер для экрана «ColorEditModule»
final class ColorEditModuleController: BaseViewController<ColorEditModulePresentable>, ColorEditModuleDisplayable {

    // MARK: - Properties
    
    private lazy var colorPickerModule: ColorPickerModule = {
        let module = ColorPickerModule()
        module.delegate = presenter.delegate
        return module
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = colorPickerModule
        collectionView.dataSource = colorPickerModule
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.registerClass(for: ColorCell.self)
        return collectionView
    }()

    // MARK: - Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
    
    // MARK: - ColorEditModuleDisplayable
    
    // MARK: - Private Functions
    
    // MARK: - Functions

    // MARK: - Actions

}
