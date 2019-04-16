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
        view.backgroundColor = .white
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "export"), style: .plain, target: self, action: #selector(exportImage))
    }
    
    override func updateViewConstraints() {
        slideArea.snp.remakeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(view.snp.topMargin)
            maker.bottom.equalTo(view.snp.bottomMargin)
        }
        let frame = view.frame
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        slideView.dropShadow()
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
        let story = presenter.story
        story.template.backgroundImage?.draw(in: CGRect(origin: .zero, size: size))
        
        story.items.forEach { item in
            guard let image = item.renderedImage else {
                return
            }
            let currentWidth = item.settings.sizeWidth * width
            let size = CGSize(width: currentWidth,
                              height: currentWidth / item.settings.ratio)
            let frame = CGRect(origin: CGPoint(x: -size.width / 2.0, y: -size.height / 2.0), size: size)
            
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()
                context.translateBy(x: width * item.settings.center.x,
                                    y: height * item.settings.center.y)
                context.concatenate(CGAffineTransform(rotationAngle: item.settings.angle))
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
    
    func photoPlaceDidBeginEditing(_ photoPlace: PhotoPlace) {
        guard let frame = photoPlace.superview?.convert(photoPlace.frame, to: self.view) else {
            return
        }
        let offset = (view.frame.height - frame.maxY) - 160
        if offset < 0 {
            slideArea.setContentOffset(CGPoint(x: 0, y: -offset), animated: true)
        }
    }
    
    func photoPlaceDidEndEditing(_ photoPlace: PhotoPlace) {
        slideArea.setContentOffset(.zero, animated: true)
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
