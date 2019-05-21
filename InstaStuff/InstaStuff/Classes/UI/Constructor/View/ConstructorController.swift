//
//  ConstructorController.swift
//  InstaStuff
//
//  Created by aezhov on 14/05/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

private struct Constatns {
    static let constructorPhotoEditViewhight: CGFloat = 220
}

/// Контроллер для экрана «Constructor»
final class ConstructorController: BaseViewController<ConstructorPresentable>, ConstructorDisplayable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditViewPeresenterDelegate {
    
    // MARK: - Properties
    
    /// Есть ли сториборд
    override class var hasStoryboard: Bool { return false }
    
    private let editViewPeresenter = EditViewPeresenter()
    
    private lazy var slideArea: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private lazy var slideView: ConstructorSlideView = {
        let view = ConstructorSlideView(editViewPeresenter: editViewPeresenter)
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var menuView: MenuView = {
        let view = MenuView()
        view.backgroundColor = Consts.Colors.applicationColor
        view.setupActions(for: self)
        return view
    }()
    
    private lazy var constructorPhotoEditView: ConstructorPhotoEditView = {
        let view = ConstructorPhotoEditView(peresenter: editViewPeresenter)
        view.backgroundColor = Consts.Colors.applicationColor
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
        editViewPeresenter.delegate = self
        setupPhotoEditMenu(hidden: true, animated: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "export"), style: .plain, target: self, action: #selector(exportImage))
    }
    
    override func updateViewConstraints() {
        slideArea.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(view.snp.topMargin)
            maker.bottom.equalTo(menuView.snp.top)
        }
        
        let ratio: CGFloat = 9.0 / 16.0
        
        slideView.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(slideView.snp.height).multipliedBy(ratio)
            maker.height.equalTo(slideArea.snp.height).inset(30)
        }
        
        menuView.snp.remakeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(44 + Consts.UIGreed.safeAreaInsetsBottom)
        }
        
        constructorPhotoEditView.snp.remakeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(Constatns.constructorPhotoEditViewhight + Consts.UIGreed.safeAreaInsetsBottom)
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
        view.addSubview(constructorPhotoEditView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    func setupPhotoEditMenu(hidden: Bool, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            self.constructorPhotoEditView.transform = hidden ? CGAffineTransform(translationX: 0, y: Constatns.constructorPhotoEditViewhight + Consts.UIGreed.safeAreaInsetsBottom) : .identity
        }
        
    }
    
    // MARK: - Actions
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc private func exportImage() {
        let width = Consts.UIGreed.screenWidth
        let height = Consts.UIGreed.screenHeight
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        
        //let story = presenter.story
        
        //story.template.backgroundColor.setFill()
        UIColor.white.setFill()
        let context = UIGraphicsGetCurrentContext()
        context?.fill(CGRect(origin: .zero, size: size))
        
        //story.template.backgroundImage?.draw(in: CGRect(origin: .zero, size: size))
        
        slideView.items.forEach { view in
            let item = view.storyEditableItem
            let scale: CGFloat = slideView.frame.width / Consts.UIGreed.screenWidth
            guard let image = item.renderedImage(scale: scale) else {
                return
            }
            
            var size: CGSize
            if item is StoryEditableTextItem {
                size = image.size
            } else {
                let currentWidth = item.settings.sizeWidth * width
                size = CGSize(width: currentWidth,
                              height: currentWidth / item.settings.ratio)
            }
            
            let frame = CGRect(origin: CGPoint(x: -size.width / 2.0, y: -size.height / 2.0), size: size)
            
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()
                context.translateBy(x: width * item.settings.center.x,
                                    y: height * item.settings.center.y)
                context.concatenate(CGAffineTransform.init(translationX: item.editableTransform.currentTranslation.x / scale,
                                                           y: item.editableTransform.currentTranslation.y / scale))
                context.concatenate(CGAffineTransform(rotationAngle: item.editableTransform.currentRotation))
                context.concatenate(CGAffineTransform(scaleX: item.editableTransform.currentScale, y: item.editableTransform.currentScale))
                image.draw(in: frame)
                context.restoreGState()
            }
        }
        
        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = myImage {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
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
            let settings = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: pickedImage.size.width/pickedImage.size.height)
            let photoItem = PhotoItem(frameName: "1", photoAreaLocation: settings)
            let settingsPhoto = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: pickedImage.size.width/pickedImage.size.height)
            let photoitem = StoryEditablePhotoItem(photoItem,
                                                   customSettings: nil,
                                                   settings: settingsPhoto)
            photoitem.update(image: pickedImage)
            let photoPlace = PhotoPlaceConstructor(photoitem)
            
            self.slideView.add(photoPlace)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
