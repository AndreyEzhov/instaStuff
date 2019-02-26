import Foundation

public func typeCast<T>(_ object: AnyObject?, type: T.Type) -> T? {
    return object as? T
}

public func className(_ class: AnyClass) -> String {
    return NSStringFromClass(`class`).components(separatedBy: ".").last!
}
