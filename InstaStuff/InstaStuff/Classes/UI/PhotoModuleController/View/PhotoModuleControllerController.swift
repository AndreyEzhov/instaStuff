//
//  PhotoModuleControllerController.swift
//  InstaStuff
//
//  Created by aezhov on 15/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

protocol SliderListener: class {
    func valueDidChanged(_ value: Float)
}

/// Контроллер для экрана «PhotoModuleController»
final class PhotoModuleControllerController: UIView, PhotoModuleControllerDisplayable {
    
    // MARK: - Properties
    
    weak var delegate: SliderListener?
    
    private var presenter: PhotoModuleControllerPresentable!
    
    private lazy var slideView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -100
        slider.maximumValue = 100
        slider.value = 0
        slider.addTarget(self, action: #selector(sliderValueDidChanged), for: .valueChanged)
        return slider
    }()
    
    private var value: Int = 0 {
        didSet {
            if value != oldValue {
                delegate?.valueDidChanged(Float(value) / 100.0)
            }
        }
    }
    
    // MARK: - Construction
    
    class func controller(presenter: PhotoModuleControllerPresentable) -> PhotoModuleControllerController {
        let view = PhotoModuleControllerController(frame: .zero)
        view.presenter = presenter
        presenter.view = view
        return view
    }
    
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
        slideView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(20)
        }
        super.updateConstraints()
    }
    
    // MARK: - TextEditorModuleDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        addSubview(slideView)
        updateConstraintsIfNeeded()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    @objc private func sliderValueDidChanged() {
        value = Int(round(slideView.value / 2))
    }
    
}
