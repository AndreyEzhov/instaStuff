//
//  TextEditorModuleController.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

private enum Constants {
    
    static let stackViewHight: CGFloat = 60
    
    static let collectionViewHight: CGFloat = 60
    
}

/// Контроллер для экрана «TextEditorModule»
final class TextEditorModuleController: UIView, TextEditorModuleDisplayable, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ColorPickerListener {
    var currentColor: UIColor? {
        return .white
    }
    // MARK: - Properties
    
    private(set) var presenter: TextEditorModulePresentable!
    
    private lazy var stackViewFirst: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(capitalisedButton)
        //stackView.addArrangedSubview(backgroundColorButton)
        stackView.addArrangedSubview(colorButton)
        stackView.addArrangedSubview(moveToFrontButton)
        stackView.addArrangedSubview(moveToBackButton)
        return stackView
    }()
    
    private lazy var stackViewSecond: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(alignmentButton)
        stackView.addArrangedSubview(fontSizeButton)
        stackView.addArrangedSubview(kernButton)
        stackView.addArrangedSubview(lineSpacingButton)
        return stackView
    }()
    
    private lazy var capitalisedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capitalised_default"), for: .normal)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(upperCase(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var alignmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(changeAlignment(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var fontSizeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "font_size_default"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "font_size_selected"), for: .selected)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(changeFontSize(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var backgroundColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "textBackground_default"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "textBackground_selected"), for: .selected)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(changeBackgroundColor(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "color_default"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "color_selected"), for: .selected)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(changeColor(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var lineSpacingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "lineSpacing_default"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "lineSpacing_selected"), for: .selected)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(changeLineSpacing(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var kernButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "kern_defalut"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "kern_selected"), for: .selected)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(changeKern(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var moveToFrontButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "moveToFront"), for: .normal)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(moveToFront(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var moveToBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "moveToBack"), for: .normal)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(moveToBack(_:)), for: .touchUpInside)
        return button
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = Consts.Colors.r219g192b178
        slider.addTarget(self, action: #selector(sliderValueDidChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    private lazy var fontsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.registerClass(for: FontCell.self)
        return collectionView
    }()
    
    private(set) lazy var colorsCollectionView: UIView = {
        return UIView()
    }()
    
    weak var pippeteDelegate: PippeteDelegate?
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: 2.0 * Constants.stackViewHight + 2.0 * Constants.stackViewHight + 20.0 + Consts.UIGreed.safeAreaInsetsBottom)
    }
    
    private lazy var singleSelectionButtons: [UIButton] = [fontSizeButton, kernButton, lineSpacingButton, colorButton, backgroundColorButton]
    
    // MARK: - Construction
    
    class func controller(presenter: TextEditorModulePresentable) -> TextEditorModuleController {
        let view = TextEditorModuleController(frame: .zero, presenter: presenter)
        presenter.view = view
        return view
    }
    
    init(frame: CGRect, presenter: TextEditorModulePresentable) {
        self.presenter = presenter
        super.init(frame: frame)
        backgroundColor = Consts.Colors.applicationColor
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func updateConstraints() {
        fontsCollectionView.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview()
            maker.height.equalTo(Constants.collectionViewHight)
        }
        stackViewFirst.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(fontsCollectionView.snp.bottom)
            maker.height.equalTo(Constants.stackViewHight)
        }
        stackViewSecond.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(stackViewFirst.snp.bottom)
            maker.height.equalTo(Constants.stackViewHight)
        }
        slider.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview().inset(16)
            maker.top.equalTo(stackViewSecond.snp.bottom)
            maker.height.equalTo(Constants.stackViewHight)
        }
        presenter.colorEditModuleController.view.snp.remakeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        colorsCollectionView.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(stackViewSecond.snp.bottom)
            maker.height.equalTo(Constants.collectionViewHight)
        }
        super.updateConstraints()
    }
    
    // MARK: - TextEditorModuleDisplayable
    
    func updateView() {
        guard let textSetups = presenter.textSetups else {
            return
        }
        alignmentButton.setImage(textSetups.aligment.image, for: .normal)
    }
    
    func updateSlider(with model: SliderModel?) {
        slider.isHidden = presenter.type.sliderType == .color
        colorsCollectionView.isHidden = presenter.type.sliderType == .slider
        switch presenter.type {
        case .fontSize:
            deselectButtons(excluding: fontSizeButton)
        case .kern:
            deselectButtons(excluding: kernButton)
        case .lineSpacing:
            deselectButtons(excluding: lineSpacingButton)
        case .color:
            deselectButtons(excluding: colorButton)
        case .backgroundColor:
            deselectButtons(excluding: backgroundColorButton)
        }
        if let model = model {
            slider.minimumValue = Float(model.minValue)
            slider.maximumValue = Float(model.maxValue)
            slider.value = Float(model.value ?? model.minValue)
        }
    }
    
    func updateColorPicker(with color: UIColor?) {
        presenter.colorEditModuleController.updateUIColor(color)
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        autoresizingMask = .flexibleHeight
        addSubview(fontsCollectionView)
        addSubview(stackViewFirst)
        addSubview(stackViewSecond)
        addSubview(slider)
        addSubview(colorsCollectionView)
        colorsCollectionView.addSubview(presenter.colorEditModuleController.view)
        updateConstraintsIfNeeded()
    }
    
    private func deselectButtons(excluding button: UIButton) {
        singleSelectionButtons.forEach {
            $0.isSelected = $0 === button
        }
    }
    
    // MARK: - Functions

    
    // MARK: - Actions
    
    @objc private func changeAlignment(_ button: UIButton) {
        let alignmentType = presenter.changeAlignment()
        button.setImage(alignmentType.image, for: .normal)
    }
    
    @objc private func upperCase(_ button: UIButton) {
        presenter.upperCase()
    }
    
    @objc private func changeFontSize(_ button: UIButton) {
        presenter.beginEdition(with: .fontSize)
    }
    
    @objc private func changeColor(_ button: UIButton) {
        presenter.beginEdition(with: .color)
    }
    
    @objc private func changeBackgroundColor(_ button: UIButton) {
        presenter.beginEdition(with: .backgroundColor)
    }
    
    @objc private func changeLineSpacing(_ button: UIButton) {
        presenter.beginEdition(with: .lineSpacing)
    }
    
    @objc private func changeKern(_ button: UIButton) {
        presenter.beginEdition(with: .kern)
    }
    
    @objc private func moveToBack(_ button: UIButton) {
        presenter.moveToBack()
    }
    
    @objc private func moveToFront(_ button: UIButton) {
        presenter.moveToFront()
    }
    
    @objc private func sliderValueDidChanged(_ slider: UISlider) {
        presenter.valueDidChanged(slider.value)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard fontsCollectionView === collectionView else {
            return 0
        }
        return presenter.fonts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard fontsCollectionView === collectionView else {
            return UICollectionViewCell()
        }
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: FontCell) in
            cell.setup(with: presenter.fonts[indexPath.row])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard fontsCollectionView === collectionView else {
            return .zero
        }
        let fontName = presenter.fonts[indexPath.row].name
        let font = UIFont(name: fontName, size: FontCell.Constants.fontSize) ?? UIFont.applicationFontRegular(ofSize: FontCell.Constants.fontSize)
        return CGSize(width: 4 + 2 * FontCell.Constants.inset + NSString(string: fontName).size(withAttributes: [.font: font]).width, height: collectionView.frame.height)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard fontsCollectionView === collectionView else {
            return
        }
        presenter.setFont(at: indexPath.row)
    }
    
    // MARK: - ColorPickerLostener
    
    func colorDidChanged(_ value: UIColor) {
        presenter.setColor(value)
    }
    
    func checkMarkTouch() {
        resignFirstResponder()
    }
    
    func placePipette(completion: @escaping (UIColor?) -> ()) {
        pippeteDelegate?.placePipette(completion: completion)
    }
}
