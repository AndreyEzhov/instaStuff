//
//  BackgroundModuleControllerController.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit


private enum Constants {
    
    static let collectionViewHight: CGFloat = 34.0
    
    static let space: CGFloat = 10.0
    
    static let doneButtonHight: CGFloat = 44.0
    
}

/// Контроллер для экрана «BackgroundModuleController»
final class BackgroundModuleControllerController: UIView, BackgroundModuleControllerDisplayable, InputViewProtocol {
    
    // MARK: - Properties
    
    weak var delegate: ColorPickerListener? {
        didSet {
            //presenter.colorPickerModule.delegate = delegate
        }
    }
    
    private var presenter: BackgroundModuleControllerPresentable!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //collectionView.delegate = presenter.colorPickerModule
        //collectionView.dataSource = presenter.colorPickerModule
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.registerClass(for: ColorCell.self)
        return collectionView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Consts.Colors.text, for: .normal)
        button.setImage(#imageLiteral(resourceName: "badge-check"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        button.titleLabel?.font = UIFont.applicationFontSemibold(ofSize: 17.0)
        return button
    }()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: Constants.collectionViewHight + Constants.space + Constants.doneButtonHight + 20.0 + Consts.UIGreed.safeAreaInsetsBottom)
    }
    
    lazy var collapseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.setImage(#imageLiteral(resourceName: "arrowBottom"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(inputViewCollapser, action: #selector(InputViewCollapser.collapseButtonAction), for: .touchUpInside)
        return button
    }()
    
    var viewsToHide: [UIView] {
        return [collectionView]
    }
    
    var isCollapsed = false
    
    let collapsedHight: CGFloat = Constants.doneButtonHight + Consts.UIGreed.safeAreaInsetsBottom
    
    private lazy var inputViewCollapser: InputViewCollapser = {
        let collapser = InputViewCollapser()
        collapser.inputView = self
        return collapser
    }()
    
    // MARK: - Construction
    
    class func controller(presenter: BackgroundModuleControllerPresentable) -> BackgroundModuleControllerController {
        let view = BackgroundModuleControllerController(presenter)
        presenter.view = view
        return view
    }
    
    init(_ presenter:BackgroundModuleControllerPresentable) {
        super.init(frame: .zero)
        backgroundColor = Consts.Colors.applicationColor
        self.presenter = presenter
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    
    override func updateConstraints() {
        doneButton.snp.remakeConstraints { maker in
            maker.top.equalToSuperview()
            maker.right.equalToSuperview().inset(20)
            maker.height.equalTo(Constants.doneButtonHight)
        }
        collapseButton.snp.remakeConstraints { maker in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.height.equalTo(Constants.doneButtonHight)
        }
        collectionView.snp.remakeConstraints { maker in
            maker.top.equalTo(doneButton.snp.bottom).offset(Constants.space)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(Constants.collectionViewHight)
        }
        super.updateConstraints()
    }
    
    // MARK: - TextEditorModuleDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        autoresizingMask = .flexibleHeight
        addSubview(collectionView)
        addSubview(doneButton)
        addSubview(collapseButton)
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    @objc private func doneButtonAction() {

    }
}
