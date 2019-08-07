//
//  StoryEditorController.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit
import SnapKit

protocol EditorDisplayer: class {
    func changeMenuSize(animated: Bool)
}

final class StoryEditorController: BaseViewController<StoryEditorPresentable>, StoryEditorDisplayable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, PhotoPicker {
    
    // MARK: - Properties
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }()
    
    private lazy var slideArea: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private lazy var slideView: StorySlideView = {
        let view = StorySlideView(slideArea: slideArea)
        view.addGestures()
        return view
    }()
    
    private(set) lazy var pipette: PipetteSubview = {
        let view = PipetteSubview()
        view.view = slideView
        return view
    }()
    
    private let offset: CGFloat = 10
    
    private var coef: CGFloat {
        return (view.bounds.width - 2 * offset) / Consts.UIGreed.screenWidth
    }
    
    private var photoDidSelectedBlock: ((UIImage) -> ())?
    
    private lazy var editorController = Assembly.shared.createEditorController(params: EditorPresenter.Parameters(delegate: self, menuViewProtocol: self))
    
    private(set) lazy var editorView: UIView = {
        let view = UIView()
        embedChildViewController(editorController, toView: view)
        return view
    }()
    
    private(set) lazy var slideViewPresenter = SlideViewPresenter(storySlideView: slideView, storyItem: presenter.story, editorPresenter: editorController.presenter as! EditorPresenter, coef: coef)
    
    var heightConstraint: ConstraintMakerEditable?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "export"), style: .plain, target: self, action: #selector(exportImageToLibrary))
        presenter.slideViewPresenter = slideViewPresenter
        editorController.presenter.update(with: .main(self))
        navigationController?.router.updateHierarchy()
        TextViewPlace.editView.presenter.pippeteDelegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.exportImage(initiatedByUser: false)
    }
    
    override func updateViewConstraints() {
        slideArea.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(view.snp.topMargin)
            maker.bottom.equalTo(view.snp.bottomMargin).inset(EditorController.Constants.toolbarHeight)
        }
        
        let ratio: CGFloat = 9.0 / 16.0
        
        slideView.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().inset(-20)
            maker.width.equalTo(slideView.snp.height).multipliedBy(ratio)
            maker.height.equalTo(slideArea.snp.height).inset(offset)
        }
        
        editorView.snp.remakeConstraints { maker in
            maker.left.right.bottom.equalToSuperview()
            heightConstraint = maker.height.equalTo(editorController.presenter.contentSize.height + Consts.UIGreed.safeAreaInsetsBottom)
        }
        
        super.updateViewConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editorView.layoutIfNeeded()
        slideView.layoutIfNeeded()
        slideView.dropShadow()
    }
    
    // MARK: - StoryEditorDisplayable
    
    func displayResult(with image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        navigationController?.router.updateHierarchy()
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(slideArea)
        slideArea.addSubview(slideView)
        view.addSubview(editorView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
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
    
    @objc private func exportImageToLibrary() {
        presenter.exportImage(initiatedByUser: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let block = photoDidSelectedBlock {
            block(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - PhotoPicker
    
    func photoPlaceDidSelected(_ photoPlace: PhotoPlace, completion: @escaping (UIImage) -> ()) {
        present(imagePicker, animated: true, completion: nil)
        photoDidSelectedBlock = completion
    }
    
    // MARK: - UITextViewDelegate
    
    //    func textViewDidBeginEditing(_ textView: UITextView) {
    //        guard let textView = textView.superview else {
    //            return
    //        }
    //        let frame = view.convert(textView.frame, to: self.view)
    //        let offset = view.frame.midY / 2.0 - frame.midY
    //        slideArea.setContentOffset(CGPoint(x: 0, y: -offset), animated: true)
    //    }
    //
    //    func textViewDidEndEditing(_ textView: UITextView) {
    //        slideArea.setContentOffset(.zero, animated: true)
    //    }
    //
    //    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    //        return true
    //    }
    
    
    
}

extension StoryEditorController: MenuViewProtocol {
    func addPhotoAction(_ sender: UIButton) {
        editorController.presenter.update(with: .addPhotoFrame)
    }
    
    func addItemAction(_ sender: UIButton) {
        editorController.presenter.update(with: .addStuff(slideViewPresenter))
    }
    
    func addTextAction(_ sender: UIButton) {
        presenter.slideViewPresenter?.add(StoryEditableTextItem.defaultItem)
    }
    
    func changeBackgroundAction(_ sender: UIButton) {
        editorController.presenter.update(with: .backgroundChange(self))
    }
    
}

extension StoryEditorController: EditorDisplayer {
    
    func changeMenuSize(animated: Bool) {
        view.layoutIfNeeded()
        heightConstraint?.constraint.layoutConstraints.first?.constant = editorController.presenter.contentSize.height + Consts.UIGreed.safeAreaInsetsBottom
        UIView.animate(withDuration: animated ? 0.3 : 0.0) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension StoryEditorController: BackgroundPickerListener {
    
    var currentColor: UIColor? {
        return presenter.story.backgroundColor
    }
    
    func colorDidChanged(_ value: UIColor) {
        presenter.slideViewPresenter?.setBackgroundColor(value)
    }
    
    func placePipette(completion: @escaping (UIColor?) -> ()) {
        guard pipette.superview == nil else { return }
        
        let image = slideView.snapshot()
        let view = UIImageView(image: image)
        
        slideArea.addSubview(view)
        slideArea.addSubview(pipette)
        pipette.view = view
        let isFirstResponder = presenter.slideViewPresenter?.selectedItem?.isFirstResponder ?? false
        presenter.slideViewPresenter?.selectedItem?.resignFirstResponder()
        pipette.completion = { color in
            if isFirstResponder {
                self.presenter.slideViewPresenter?.selectedItem?.becomeFirstResponder()
            }
            self.editorView.isHidden = false
            completion(color)
        }
        pipette.frame = slideView.frame
        view.frame = slideView.frame
        editorView.isHidden = true

    }
    
    func backgroundImageDidChanged(_ imageName: String?) {
        presenter.slideViewPresenter?.setBackgroundImage(imageName)
    }
}
