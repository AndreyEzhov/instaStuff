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
    
    private(set) var presenter: TextEditorModulePresentable!
    
    /// Есть ли сториборд
    class func controller(presenter: TextEditorModulePresentable) -> TextEditorModuleController {
        let view = TextEditorModuleController(frame: .zero)
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
    private lazy var stackViewFirst: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(boldButton)
        stackView.addArrangedSubview(italicaButton)
        stackView.addArrangedSubview(capitalisedButton)
        stackView.addArrangedSubview(alignmentButton)
        return stackView
    }()
    
    private lazy var stackViewSecond: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(fontSizeButton)
        stackView.addArrangedSubview(colorButton)
        stackView.addArrangedSubview(kernButton)
        stackView.addArrangedSubview(lineSpacingButton)
        return stackView
    }()
    
    private lazy var boldButton: UIButton = {
        let boldButton = UIButton(type: .system)
        boldButton.setImage(#imageLiteral(resourceName: "bold_default"), for: .normal)
        boldButton.setImage(#imageLiteral(resourceName: "bold_selected"), for: .selected)
        boldButton.tintColor = .clear
        boldButton.addTarget(self, action: #selector(makeBold(_:)), for: .touchUpInside)
        return boldButton
    }()
    
    private lazy var italicaButton: UIButton = {
        let italicaButton = UIButton(type: .system)
        italicaButton.setImage(#imageLiteral(resourceName: "italic_default"), for: .normal)
        italicaButton.setImage(#imageLiteral(resourceName: "italic_selected"), for: .selected)
        italicaButton.tintColor = .clear
        italicaButton.addTarget(self, action: #selector(makeItalic(_:)), for: .touchUpInside)
        return italicaButton
    }()
    
    private lazy var capitalisedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capitalised_default"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "capitalised_selected"), for: .selected)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(upperCase(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var  alignmentButton: UIButton = {
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
    
    private lazy var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.registerClass(for: ColorCell.self)
        return collectionView
    }()
    
    private lazy var singleSelectionButtons: [UIButton] = [fontSizeButton, kernButton, lineSpacingButton, colorButton]
    
    // MARK: - Construction
    
    override init(frame: CGRect) {
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
            maker.height.equalTo(60)
        }
        stackViewFirst.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(fontsCollectionView.snp.bottom)
            maker.height.equalTo(60)
        }
        stackViewSecond.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(stackViewFirst.snp.bottom)
            maker.height.equalTo(60)
        }
        slider.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview().inset(16)
            maker.top.equalTo(stackViewSecond.snp.bottom)
            maker.height.equalTo(60)
        }
        colorsCollectionView.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(stackViewSecond.snp.bottom)
            maker.height.equalTo(60)
        }
        super.updateConstraints()
    }
    
    // MARK: - TextEditorModuleDisplayable
    
    func updateView() {
        guard let textSetups = presenter.textSetups else {
            return
        }
        updateBoldItalic()
        alignmentButton.setImage(textSetups.aligment.image, for: .normal)
        alignmentButton.isSelected = textSetups.isUpperCase
    }
    
    func updateSlider(with model: SliderModel?) {
        slider.isHidden = presenter.type == .color
        colorsCollectionView.isHidden = presenter.type != .color
        switch presenter.type {
        case .fontSize:
            deselectButtons(excluding: fontSizeButton)
        case .kern:
            deselectButtons(excluding: kernButton)
        case .lineSpacing:
            deselectButtons(excluding: lineSpacingButton)
        case .color:
            deselectButtons(excluding: colorButton)
        }
        if let model = model {
            slider.minimumValue = Float(model.minValue)
            slider.maximumValue = Float(model.maxValue)
            slider.value = Float(model.value ?? model.minValue)
        }
    }
    
    // MARK: - Private Functions
    
    private func updateBoldItalic() {
        guard let textSetups = presenter.textSetups else {
            return
        }
        boldButton.isEnabled = textSetups.canBeBold
        italicaButton.isEnabled = textSetups.canBeItalic
        boldButton.isSelected = textSetups.isBold
        italicaButton.isSelected = textSetups.isItalic
    }
    
    private func setup() {
        addSubview(fontsCollectionView)
        addSubview(stackViewFirst)
        addSubview(stackViewSecond)
        addSubview(slider)
        addSubview(colorsCollectionView)
        updateConstraintsIfNeeded()
    }
    
    private func deselectButtons(excluding button: UIButton) {
        singleSelectionButtons.forEach {
            $0.isSelected = $0 === button
        }
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    @objc private func makeBold(_ button: UIButton) {
        button.isSelected = presenter.makeBold()
    }
    
    @objc private func makeItalic(_ button: UIButton) {
        button.isSelected = presenter.makeItalic()
    }
    
    @objc private func changeAlignment(_ button: UIButton) {
        let alignmentType = presenter.changeAlignment()
        button.setImage(alignmentType.image, for: .normal)
    }
    
    @objc private func upperCase(_ button: UIButton) {
        button.isSelected = presenter.upperCase()
    }
    
    @objc private func changeFontSize(_ button: UIButton) {
        presenter.beginEdition(with: .fontSize)
    }
    
    @objc private func changeColor(_ button: UIButton) {
        presenter.beginEdition(with: .color)
    }
    
    @objc private func changeLineSpacing(_ button: UIButton) {
        presenter.beginEdition(with: .lineSpacing)
    }
    
    @objc private func changeKern(_ button: UIButton) {
        presenter.beginEdition(with: .kern)
    }
    
    @objc private func sliderValueDidChanged(_ slider: UISlider) {
        presenter.valueDidChanged(slider.value)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard fontsCollectionView === collectionView else {
            return presenter.colors.count
        }
        return presenter.fonts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard fontsCollectionView === collectionView else {
            return collectionView.dequeue(indexPath: indexPath, with: { (cell: ColorCell) in
                cell.setup(with: presenter.colors[indexPath.row])
            })
        }
        return collectionView.dequeue(indexPath: indexPath, with: { (cell: FontCell) in
            cell.setup(with: presenter.fonts[indexPath.row])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard fontsCollectionView === collectionView else {
            return CGSize(width: 34, height: 34)
        }
        let fontName = presenter.fonts[indexPath.row].name
        let font = UIFont(name: fontName, size: FontCell.Constants.fontSize) ?? UIFont.applicationFontRegular(ofSize: FontCell.Constants.fontSize)
        return CGSize(width: 4 + 2 * FontCell.Constants.inset + NSString(string: fontName).size(withAttributes: [.font: font]).width, height: collectionView.frame.height)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard fontsCollectionView === collectionView else {
            presenter.setColor(at: indexPath.row)
            return
        }
        presenter.setFont(at: indexPath.row)
        updateBoldItalic()
    }
    
}
