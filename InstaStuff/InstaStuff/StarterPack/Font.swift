import UIKit

extension UIFont {
    
    // MARK: - Properties
    
    static let chalkboard = "Chalkboard SE"
    
    static let applicationFontName = "System"
    
    static var applicationFontFamilyName: String {
        return UIFont.applicationFontRegular(ofSize: 10.0).familyName
    }
    
    // MARK: - Nested Types
    
    public enum FontWeight {
        case weight100
        case weight200
        case weight300
        case weight400
        case weight500
        case weight600
        case weight700
        case weight800
        case weight900
        case ultraLight
        case thin
        case light
        case regular
        case medium
        case semibold
        case bold
        case heavy
        case black
        
        var weight: UIFont.Weight {
            switch self {
            case .weight100, .ultraLight: return UIFont.Weight.ultraLight
            case .weight200, .thin: return UIFont.Weight.thin
            case .weight300, .light: return UIFont.Weight.light
            case .weight400, .regular: return UIFont.Weight.regular
            case .weight500, .medium: return UIFont.Weight.medium
            case .weight600, .semibold: return UIFont.Weight.semibold
            case .weight700, .bold: return UIFont.Weight.bold
            case .weight800, .heavy: return UIFont.Weight.heavy
            case .weight900, .black: return UIFont.Weight.black
            }
        }
        
        var fontName: String {
            switch self {
            case .weight100, .ultraLight: return "\(UIFont.applicationFontName)-UltraLight"
            case .weight200, .thin: return "\(UIFont.applicationFontName)-Thin"
            case .weight300, .light: return "\(UIFont.applicationFontName)-Light"
            case .weight400, .regular: return "\(UIFont.applicationFontName)-Regular"
            case .weight500, .medium: return "\(UIFont.applicationFontName)-Medium"
            case .weight600, .semibold: return "\(UIFont.applicationFontName)-Semibold"
            case .weight700, .bold: return "\(UIFont.applicationFontName)-Bold"
            case .weight800, .heavy: return "\(UIFont.applicationFontName)-Heavy"
            case .weight900, .black: return "\(UIFont.applicationFontName)-Black"
            }
        }
    }
    
    // MARK: - Functions
    
    open class func applicationFontNameFont(ofSize fontSize: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: weight.fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: weight.weight)
    }
    
    open class func applicationFontRegular(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.applicationFontNameFont(ofSize: fontSize, weight: FontWeight.regular)
    }
    
    open class func applicationFontBold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.applicationFontNameFont(ofSize: fontSize, weight: FontWeight.bold)
    }
    
    open class func applicationFontSemibold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.applicationFontNameFont(ofSize: fontSize, weight: FontWeight.semibold)
    }
    
    open class func applicationFontThin(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.applicationFontNameFont(ofSize: fontSize, weight: FontWeight.thin)
    }
    
}

extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
