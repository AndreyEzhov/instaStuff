//
//  ConstructorController.swift
//  InstaStuff
//
//  Created by aezhov on 14/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

/// Контроллер для экрана «Constructor»
final class ConstructorController: BaseViewController<ConstructorPresentable>, ConstructorDisplayable, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    /// Есть ли сториборд
    override class var hasStoryboard: Bool { return false }
    
    private lazy var slideArea: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private lazy var slideView: ConstructorSlideView = {
        let view = ConstructorSlideView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var menuView: MenuView = {
        let view = MenuView()
        view.backgroundColor = Consts.Colors.applicationColor
        view.setupActions(for: self)
        return view
    }()
    
    private(set) lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideView.layoutIfNeeded()
        menuView.layoutIfNeeded()
        slideView.dropShadow()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func updateViewConstraints() {
        slideArea.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(view.snp.topMargin)
            maker.bottom.equalTo(view.snp.bottomMargin)
        }
        
        let ratio: CGFloat = 9.0 / 16.0
        
        slideView.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().inset(-20)
            maker.width.equalTo(slideView.snp.height).multipliedBy(ratio)
            maker.height.equalTo(slideArea.snp.height).inset(30)
        }
        
        menuView.snp.remakeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(114 + Consts.UIGreed.safeAreaInsetsBottom)
        }
        
        super.updateViewConstraints()
    }
    
    // MARK: - ConstructorDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(slideArea)
        slideArea.addSubview(slideView)
        view.addSubview(menuView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
    
}


extension ConstructorController: MenuViewProtocol {
    
    func addPhotoAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func addItemAction(_ sender: UIButton) {
        
    }
    
    func addTextAction(_ sender: UIButton) {
        
    }
    
    func changeBackgroundAction(_ sender: UIButton) {
        
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let settings = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: pickedImage.size.width/pickedImage.size.height)
            let photoItem = PhotoItem(frameName: "1", photoAreaLocation: settings)
            let settingsPhoto = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: pickedImage.size.width/pickedImage.size.height)
            let photoitem = ConstructorPhotoPlace(photoItem,
                                                  customSettings: nil,
                                                  settings: settingsPhoto)
            photoitem.update(image: pickedImage)
            let photoPlace = PhotoPlace(photoitem)
            
            self.slideView.add(photoPlace)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
