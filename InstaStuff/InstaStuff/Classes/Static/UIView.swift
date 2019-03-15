//
//  UIView.swift
//  InstaStuff
//
//  Created by aezhov on 14/03/2019.
//  Copyright © 2019 Андрей Ежов. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.16
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 6
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// Задает состояние нажатости пользователем
    ///
    /// - Parameters:
    ///   - tapped: Нажатие?
    ///   - animated: Анимационно?
    func setTappedState(_ tapped: Bool, animated: Bool) {
        let action = {
            if tapped {
                let scale: CGFloat = 0.95
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            } else {
                self.transform = .identity
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.2,
                           animations: action)
        } else {
            action()
        }
    }
    
    /// Произвести анимацию встряхивания
    ///
    /// - Parameter power: Мощность встряхивания (Максимальный отступ от текущей позиции элемента)
    func doShakeAnimation(power: CGFloat = 20) {
        self.transform = CGAffineTransform(translationX: power, y: 0)
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: {
                        self.transform = CGAffineTransform.identity
        },
                       completion: nil)
    }
    
}
