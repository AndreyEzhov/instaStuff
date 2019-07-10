//
//  StoryPickerController.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import SnapKit

final class MainScreenController: BaseViewController<MainScreenPresentable>, MainScreenDisplayable {
    
    // MARK: - Properties
    
    override var navigationBarStyle: UINavigationBar.AppStyle {
        return .transparent
    }
    
    private lazy var chooseTemplateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.applicationFontRegular(ofSize: 16)
        label.text = Strings.Mail.chooseBestReadyTemplate
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var chooseTemplateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "completedTemplateImage"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(routeToTemplates), for: .touchUpInside)
        return button
    }()
    
    private lazy var chooseConstructorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.applicationFontRegular(ofSize: 16)
        label.text = Strings.Mail.createYourUnicHistory
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var chooseConstructorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plusIcon"), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(routeToConstructor), for: .touchUpInside)
        return button
    }()
    
    private lazy var leftPartLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    
    private lazy var rightPartLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = Consts.Colors.applicationColor.cgColor
        return layer
    }()
    
    private lazy var leftContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var rightContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        leftContainerView.snp.remakeConstraints { maker in
            maker.height.equalTo(400)
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview().multipliedBy(0.5)
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        rightContainerView.snp.remakeConstraints { maker in
            maker.height.equalTo(400)
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview().multipliedBy(1.5)
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        chooseTemplateLabel.snp.remakeConstraints { maker in
            maker.width.equalToSuperview()
            maker.top.left.right.equalToSuperview()
            maker.bottom.equalTo(chooseTemplateButton.snp.top)
        }
        chooseTemplateButton.snp.remakeConstraints { maker in
            maker.width.equalToSuperview().offset(-20)
            maker.bottom.centerX.equalToSuperview()
            maker.height.equalTo(chooseTemplateButton.snp.width).multipliedBy(867.0/530.0)
        }
        chooseConstructorLabel.snp.remakeConstraints { maker in
            maker.width.equalToSuperview()
            maker.bottom.left.right.equalToSuperview()
            maker.top.equalTo(chooseConstructorButton.snp.bottom)
        }
        chooseConstructorButton.snp.remakeConstraints { maker in
            maker.width.equalToSuperview().offset(-40)
            maker.top.centerX.equalToSuperview()
            maker.height.equalTo(chooseTemplateButton.snp.width).multipliedBy(265.0/148.0)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let halfWidth = view.frame.width / 2.0
        leftPartLayer.frame = CGRect(x: 0, y: 0, width: halfWidth, height: view.frame.height)
        rightPartLayer.frame = CGRect(x: halfWidth, y: 0, width: halfWidth, height: view.frame.height)
        chooseConstructorButton.dropShadow()
    }
    
    // MARK: - StoryPickerDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        view.layer.addSublayer(leftPartLayer)
        view.layer.addSublayer(rightPartLayer)
        view.addSubview(leftContainerView)
        view.addSubview(rightContainerView)
        leftContainerView.addSubview(chooseTemplateLabel)
        leftContainerView.addSubview(chooseTemplateButton)
        rightContainerView.addSubview(chooseConstructorLabel)
        rightContainerView.addSubview(chooseConstructorButton)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
    @objc private func routeToTemplates() {
        navigationController?.router.routeToTemplatePicker(params: TemplatePickerPresenter.Parameters())
    }
    
    @objc private func routeToConstructor() {
        navigationController?.router.routeToStoryEditor(parameters: StoryEditorPresenter.Parameters(template: Template(), isEditable: true))
    }
    
}
