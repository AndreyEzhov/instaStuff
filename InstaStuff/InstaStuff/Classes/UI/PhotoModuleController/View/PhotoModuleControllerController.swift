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
        slider.minimumValue = 0
        slider.maximumValue = 100
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
        slideView.value = presenter.initilaValue * 100
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    @objc private func sliderValueDidChanged() {
        value = Int(round(slideView.value))
    }
    
}
