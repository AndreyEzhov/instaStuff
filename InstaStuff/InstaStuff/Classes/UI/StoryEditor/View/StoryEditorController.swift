//
//  StoryEditorController.swift
//  InstaStuff
//
//  Created by Андрей Ежов on 23.02.2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

final class StoryEditorController: BaseViewController<StoryEditorPresentable>, StoryEditorDisplayable, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, PhotoPicker, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    
    override class var hasStoryboard: Bool { return false }
    
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
        let view = StorySlideView(slide: presenter.story)
        view.photoPlaces.forEach {
            ($0 as? PhotoPlace)?.delegate = self
            ($0 as? TextViewPlace)?.delegate = self
        }
        return view
    }()

    private var photoDidSelectedBlock: ((UIImage) -> ())?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTap()
    }
    
    override func updateViewConstraints() {
        slideArea.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(view.snp.topMargin)
            maker.bottom.equalTo(view.snp.bottomMargin)
        }
        let frame = slideView.frame
        let ratio: CGFloat = 9.0 / 16.0
        
        slideView.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(slideView.snp.height).multipliedBy(ratio)
            if (frame.height / frame.width) > ratio {
                maker.height.equalToSuperview().multipliedBy(0.95)
            } else {
                maker.width.equalToSuperview().multipliedBy(0.95)
            }
        }
        super.updateViewConstraints()
    }
    
    private func setupTap() {
        let tap = UITapGestureRecognizer()
        view.addGestureRecognizer(tap)
        tap.addTarget(self, action: #selector(tapGesture(_:)))
        tap.delegate = self
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    @objc private func tapGesture(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        view.endEditing(true)
    }
    
    // MARK: - StoryEditorDisplayable
    
    // MARK: - Private Functions
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(slideArea)
        slideArea.addSubview(slideView)
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - Functions
    
    // MARK: - Actions

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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let frame = textView.superview?.convert(textView.frame, to: self.view) else {
            return
        }
        let offset = (view.frame.height - frame.maxY) - 400
        if offset < 0 {
            slideArea.setContentOffset(CGPoint(x: 0, y: -offset), animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        slideArea.setContentOffset(.zero, animated: true)
    }
    
}
