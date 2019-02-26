import UIKit

extension UIScreen {
    
    enum KindOfSize {
        case small
        case medium
        case big
        
        func value<T>(small: T, big: T) -> T {
            return value(small: small, big: big, medium: big)
        }
        
        func value<T>(small: T, big: T, medium: T) -> T {
            switch self {
            case .small:
                return small
            case .medium:
                return medium
            case .big:
                return big
            }
        }
    }
    
    static let kindOfSize: KindOfSize = {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth >= 414 {
            return .big
        } else if screenWidth >= 375 {
            return .medium
        } else {
            return .small
        }
    }()
    
}
