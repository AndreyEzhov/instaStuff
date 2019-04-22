//
//  PhotoModuleControllerController.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol SliderListener: UIView {
    func valueDidChanged(_ value: Float)
}

private enum Constants {
    
    static let sliderHight: CGFloat = 44.0
    
    static let doneButtonHight: CGFloat = 44.0
    
}

/// Контроллер для экрана «PhotoModuleController»
final class PhotoModuleControllerController: UIView, PhotoModuleControllerDisplayable {
    
    // MARK: - Properties
    
    weak var delegate: SliderListener?
    
    private var presenter: PhotoModuleControllerPresentable!
    
    private lazy var slideView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderValueDidChanged), for: .valueChanged)
        return slider
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Consts.Colors.text, for: .normal)
        button.setTitle(Strings.Common.done, for: .normal)
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        button.titleLabel?.font = UIFont.applicationFontSemibold(ofSize: 17.0)
        return button
    }()
    
    private var value: Int = 0 {
        didSet {
            if value != oldValue {
                delegate?.valueDidChanged(Float(value) / 100.0)
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width,
                      height: Constants.sliderHight + Constants.doneButtonHight + 20.0 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
    }
    
    // MARK: - Construction
    
    class func controller(presenter: PhotoModuleControllerPresentable) -> PhotoModuleControllerController {
        let view = PhotoModuleControllerController(presenter)
        presenter.view = view
        return view
    }
    
    init(_ presenter: PhotoModuleControllerPresentable) {
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
        slideView.snp.remakeConstraints { maker in
            maker.top.equalTo(doneButton.snp.bottom)
            maker.left.right.equalToSuperview().inset(20)
            maker.height.equalTo(Constants.sliderHight)
        }
        super.updateConstraints()
    }
    
    // MARK: - TextEditorModuleDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        autoresizingMask = .flexibleHeight
        addSubview(slideView)
        addSubview(doneButton)
        updateConstraintsIfNeeded()
        slideView.value = presenter.initilaValue * 100
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    @objc private func sliderValueDidChanged() {
        value = Int(round(slideView.value))
    }
    
    @objc private func doneButtonAction() {
        delegate?.resignFirstResponder()
    }
    
}
