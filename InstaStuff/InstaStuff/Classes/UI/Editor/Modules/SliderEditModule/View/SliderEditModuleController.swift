//
//  SliderEditModuleController.swift
//  InstaStuff
//
//  Created by aezhov on 19/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Контроллер для экрана «SliderEditModule»
final class SliderEditModuleController: BaseViewController<SliderEditModulePresentable>, SliderEditModuleDisplayable {

    // MARK: - Properties
    
    private lazy var slideView: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.addTarget(self, action: #selector(sliderValueDidChanged), for: .valueChanged)
        slider.setThumbImage(UIImage(), for: .normal)
        slider.tintColor = #colorLiteral(red: 0.8588235294, green: 0.7529411765, blue: 0.6980392157, alpha: 1)
        return slider
    }()

    // MARK: - Life Cycle

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideView.frame = CGRect(x: 30, y: 0, width: view.bounds.width - 60, height: view.bounds.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slideView)
        slideView.value = Float(presenter.value * 100)
    }
    
    // MARK: - SliderEditModuleDisplayable
    
    // MARK: - Private Functions
    
    // MARK: - Functions

    // MARK: - Actions
    
    @objc private func sliderValueDidChanged() {
        presenter.value = Int(round(slideView.value))
    }

}
