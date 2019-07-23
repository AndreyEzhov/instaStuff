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
final class ConstructorController: BaseViewController<ConstructorPresentable>, ConstructorDisplayable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, EditViewPeresenterDelegate, ColorPickerListener {
    var currentColor: UIColor? {
        return .white
    }
    // MARK: - Properties
    
    deinit {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private lazy var slideArea: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private(set) lazy var slideView: ConstructorSlideView = {
        let view = ConstructorSlideView(editViewPeresenter: presenter.editViewPeresenter)
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
    
    private(set) lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()
    
    private let editorController: EditorController! = nil
    
    private(set) lazy var editorView: UIView = {
        let view = UIView()
        embedChildViewController(editorController, toView: view)
        return view
    }()
    
    private(set) lazy var pipette: PipetteSubview = {
        let view = PipetteSubview()
        view.view = slideView
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideView.layoutIfNeeded()
        menuView.layoutIfNeeded()
        slideView.dropShadow()
        presenter.editViewPeresenter.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setup()
        setupColorEditMenu(hidden: true, animated: false, with: [])
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
        
        editorView.snp.remakeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            maker.size.equalTo(editorController.presenter.contentSize)
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
        view.addSubview(editorView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    func setupColorEditMenu(hidden: Bool, animated: Bool, with modules: [EditModule]) {
//        editorController.presenter?.update(with: modules)
//        editorView.snp.remakeConstraints { maker in
//            maker.left.right.bottom.equalToSuperview()
//            maker.height.equalTo(editorController.contentSize.height + view.safeAreaInsets.bottom)
//        }
//        view.layoutSubviews()
//        UIView.animate(withDuration: animated ? 0.3 : 0) {
//            self.editorView.transform = hidden ? CGAffineTransform(translationX: 0, y: self.editorController.contentSize.height + self.view.safeAreaInsets.bottom) : .identity
//        }
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

    }
    
    
}

extension ConstructorController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ConstructorController: MenuViewProtocol {
    
    func addPhotoAction(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func addItemAction(_ sender: UIButton) {
        let controller = Assembly.shared.createItemEditModuleController(params: ItemEditModulePresenter.Parameters(numberOfRows: 2))
        //controller.presenter.slideView = slideView
        let module = EditModule(estimatedHeight: 120, controller: controller)
        setupColorEditMenu(hidden: false, animated: true, with: [module])
    }
    
    func addTextAction(_ sender: UIButton) {
//        let textSetups = TextSetups(textType: TextSetups.TextType.none, aligment: .center, fontSize: 20, lineSpacing: 1, fontType: .futura, kern: 1, color: .black)
//        let textItem = TextItem(textSetups: textSetups, defautText: "Type your text")
//        let settings = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: 2)
//        let storyEditableTextItem = StoryEditableTextItem(textItem, settings: settings)
//        let textViewPlace = TextViewPlace(storyEditableTextItem)
//        slideView.add(textViewPlace)
    }
    
    func changeBackgroundAction(_ sender: UIButton) {
        let module = EditModule(estimatedHeight: 60, controller: Assembly.shared.createColorEditModuleController(params: ColorEditModulePresenter.Parameters(delegate: self)))
        setupColorEditMenu(hidden: false, animated: true, with: [module])
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            let settings = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 1, angle: 0, ratio: pickedImage.size.width/pickedImage.size.height)
//            let photoItem = PhotoItem(frameName: "1", photoAreaLocation: settings)
//            let settingsPhoto = Settings(center: CGPoint(x: 0.5, y: 0.5), sizeWidth: 0.8, angle: 0, ratio: pickedImage.size.width/pickedImage.size.height)
//            let photoitem = StoryEditablePhotoItem(photoItem,
//                                                   customSettings: nil,
//                                                   settings: settingsPhoto)
//            photoitem.update(image: pickedImage)
//            let photoPlace = PhotoPlaceConstructor(photoitem)
//            
//            self.slideView.add(photoPlace)
//        }
//        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - ColorPickerListener
    
    func colorDidChanged(_ value: UIColor) {
        slideView.setColor(value)
    }
    
    func checkMarkTouch() {
        setupColorEditMenu(hidden: true, animated: true, with: [])
    }
    
    func placePipette(completion: @escaping (UIColor?) -> ()) {
        guard pipette.superview == nil else { return }
        slideView.removeSelection()
        
        let image = slideView.snapshot()
        let view = UIImageView(image: image)
        
        slideArea.addSubview(view)
        slideArea.addSubview(pipette)
        pipette.view = view
        pipette.completion = completion
        pipette.frame = slideView.frame
        view.frame = slideView.frame
    }
}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}


