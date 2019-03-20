import UIKit

extension NSParagraphStyle {
    
    /// Стандартный параграф стайл с конфигруацией блоком
    ///
    /// - Parameter configureBlock: Блок конфигурации
    /// - Returns: NSParagraphStyle
    static func `default`(configureBlock: (NSMutableParagraphStyle) -> Void) -> NSParagraphStyle {
        let style = (NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle) ?? NSMutableParagraphStyle()
        configureBlock(style)
        return (style.copy() as? NSParagraphStyle) ?? style
    }
    
}
