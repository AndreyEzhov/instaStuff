import UIKit

private var appStyleKey: UInt8 = 0

extension UINavigationBar {
    
    /// Текущий стиль
    private var appStyle: AppStyle? {
        get {
            return objc_getAssociatedObject(self, &appStyleKey) as? AppStyle
        }
        set {
            objc_setAssociatedObject(self, &appStyleKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Стили приложения
    @objc enum AppStyle: Int {
        case transparent
        case transparentWhite
        case `default`
    }
    
    func applyAppStyle(_ style: AppStyle) {
        guard appStyle != style else {
            return
        }
        
        switch style {
        case .default:
            shadowImage = nil
            setBackgroundImage(nil, for: .default)
        case .transparent:
            shadowImage = UIImage()
            setBackgroundImage(UIImage(), for: .default)
        case .transparentWhite:
            setBackgroundImage(UIImage(), for: .default)
            shadowImage = UIImage()
            tintColor = UIColor.white
        }
        
        appStyle = style
    }
    
}
