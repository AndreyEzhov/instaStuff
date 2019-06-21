//
//  UIViewController+Ext.swift
//  InstaStuff
//
//  Created by aezhov on 18/06/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Functions
    
    public class func instantiateFromStoryboard() -> Self {
        let storyboardName = className(self)
        let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
        return typeCast(controller, type: self)!
    }
    
    public func embedChildViewController(_ childController: UIViewController, toView childContainerView: UIView) {
        guard let view = childController.view else {
            return
        }
        
        addChild(childController)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        childController.beginAppearanceTransition(true, animated: false)
        childContainerView.addSubview(view)
        let views = [ "v": view ]
        let rules = [ "V:|[v]|", "H:|[v]|" ]
        for rule in rules {
            childContainerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: rule, options: [], metrics: nil, views: views))
        }
        
        childController.didMove(toParent: self)
        childController.endAppearanceTransition()
    }
    
    public func unembedChildViewController(_ controller: UIViewController?) {
        guard let controller = controller else {
            return
        }
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }

}
