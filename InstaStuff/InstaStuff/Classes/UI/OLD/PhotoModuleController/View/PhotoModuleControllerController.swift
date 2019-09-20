//
//  PhotoModuleControllerController.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

private enum Constants {
    
    static let sliderHight: CGFloat = 44.0
    
    static let doneButtonHight: CGFloat = 44.0
    
    static let spaceHight: CGFloat = 20.0
    
}

/// Контроллер для экрана «PhotoModuleController»
final class PhotoModuleControllerController: UIView, PhotoModuleControllerDisplayable, InputViewProtocol {
    
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
        button.setTitle("", for: .normal)
        button.setImage(#imageLiteral(resourceName: "badge-check"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
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
                      height: Constants.sliderHight + Constants.doneButtonHight + Constants.spaceHight + Consts.UIGreed.safeAreaInsetsBottom)
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
        return [slideView]
    }
    
    var isCollapsed = false
    
    var collapsedHight: CGFloat = Constants.doneButtonHight + Consts.UIGreed.safeAreaInsetsBottom
    
    private lazy var inputViewCollapser: InputViewCollapser = {
        let collapser = InputViewCollapser()
        collapser.inputView = self
        return collapser
    }()
    
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
        collapseButton.snp.remakeConstraints { maker in
            maker.top.equalToSuperview()
            maker.centerX.equalToSuperview()
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
        addSubview(collapseButton)
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

protocol InputViewProtocol: UIView {
    var isCollapsed: Bool { get set }
    var collapseButton: UIButton { get }
    var collapsedHight: CGFloat { get }
    var viewsToHide: [UIView] { get }
}

class InputViewCollapser {
    
    var inputView: InputViewProtocol?
    
    @objc func collapseButtonAction() {
        guard let inputView = inputView else { return }
        UIView.animate(withDuration: 0.3) {
            inputView.isCollapsed.toggle()
            if inputView.isCollapsed {
                inputView.collapseButton.transform = .init(rotationAngle: .pi)
                inputView.superview?.transform = .init(translationX: 0, y: inputView.frame.height - inputView.collapsedHight)
                inputView.viewsToHide.forEach {
                    $0.alpha = 0
                    $0.isUserInteractionEnabled = false
                }
            } else {
                inputView.collapseButton.transform = .identity
                inputView.superview?.transform = .identity
                inputView.viewsToHide.forEach {
                    $0.alpha = 1
                    $0.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func applyDefaultTransform() {
        inputView?.superview?.transform = .identity
    }
    
}
