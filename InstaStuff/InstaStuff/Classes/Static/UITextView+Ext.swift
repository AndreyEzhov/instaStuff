//
//  UITextView+Ext.swift
//  InstaStuff
//
//  Created by aezhov on 13/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

extension TextViewPlace {
    
    static let editView: TextEditorModuleController = {
        return Assembly.shared.createTextEditorModuleController(params: TextEditorModulePresenter.Parameters())
    }()
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let changeEdit = UIBarButtonItem(image: #imageLiteral(resourceName: "Subtraction 1"), style: .done, target: self, action: #selector(self.changeEditableView))
        changeEdit.tintColor = Consts.Colors.text
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(image: #imageLiteral(resourceName: "badge-check"), style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = Consts.Colors.text
        
        let items = [changeEdit, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        doneToolbar.isTranslucent = false
        textView.inputAccessoryView = doneToolbar
        updateToolbarImage()
        updateToolbarColor()
    }
    
    private func updateToolbarImage() {
        ((textView.inputAccessoryView as? UIToolbar)?.items?.first)?.image = textView.inputView == nil ? #imageLiteral(resourceName: "pencil") : #imageLiteral(resourceName: "Subtraction 1")
    }
    
    @objc private func doneButtonAction() {
        _ = textView.resignFirstResponder()
    }
    
    @objc private func changeEditableView() {
        var image: UIImage?
        defer {
            updateToolbarImage()
            updateToolbarColor()
            textView.reloadInputViews()
        }
        guard textView.inputView == nil else {
            textView.inputView = nil
            return
        }
        textView.inputView = TextViewPlace.editView
        TextViewPlace.editView.presenter.textSetups = self.storyEditableTextItem.textItem.textSetups
        //TextViewPlace.editView.update(colorPickerModule: colorPickerModule)
    }
    
    private func updateToolbarColor() {
        guard textView.inputView == nil else {
            (textView.inputAccessoryView as? UIToolbar)?.barTintColor = Consts.Colors.applicationColor
            return
        }
        (textView.inputAccessoryView as? UIToolbar)?.barTintColor = Consts.Colors.keyboardColor
    }
}
