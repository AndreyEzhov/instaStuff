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
        let view = Assembly.shared.createTextEditorModuleController(params: TextEditorModulePresenter.Parameters())
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 335-44)
        return view
    }()
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let changeEdit = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(self.changeEditableView))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [changeEdit, flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        _ = resignFirstResponder()
    }
    
    @objc private func changeEditableView() {
        defer {
            reloadInputViews()
        }
        guard inputView == nil else {
            inputView = nil
            return
        }
        inputView = TextViewPlace.editView
        
    }
}
