import UIKit

extension UITableView {
    public func dequeue <CellType: UITableViewCell> (forIdentifier identifier: String = className(CellType.self), with configurator: ((_ cell: CellType) -> Void)) -> UITableViewCell {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? CellType else {
            return UITableViewCell()
        }
        
        configurator(cell)
        
        return cell
    }
    
    public func dequeueHeaderFooter <HeaderFooterType: UITableViewHeaderFooterView> (forIdentifier identifier: String = className(HeaderFooterType.self), with configurator: ((_ headerFooter: HeaderFooterType) -> Void)) -> UITableViewHeaderFooterView {
        guard let headerFooter = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? HeaderFooterType else {
            return UITableViewHeaderFooterView()
        }
        
        configurator(headerFooter)
        
        return headerFooter
    }
    
    func registerNib(for cellType: UITableViewCell.Type) {
        let nib = UINib(nibName: className(cellType), bundle: nil)
        register(nib, forCellReuseIdentifier: className(cellType.self))
    }
    
    func registerNib(for headerFooterType: UITableViewHeaderFooterView.Type) {
        let nib = UINib(nibName: className(headerFooterType), bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: className(headerFooterType.self))
    }
    
    func registerClass(for cellType: UITableViewCell.Type) {
        register(cellType, forCellReuseIdentifier: className(cellType))
    }
    
    func registerClass(for headerFooterType: UITableViewHeaderFooterView.Type) {
        register(headerFooterType, forHeaderFooterViewReuseIdentifier: className(headerFooterType.self))
    }
    
}
