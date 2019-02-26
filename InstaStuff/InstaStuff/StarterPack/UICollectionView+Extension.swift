import UIKit

extension UICollectionView {
    
    public func dequeue<CellType: UICollectionViewCell>(forIdentifier identifier: String = className(CellType.self),
                                                        indexPath: IndexPath,
                                                        with configurator: ((_ cell: CellType) -> Void)) -> UICollectionViewCell {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CellType else {
            return UICollectionViewCell()
        }
        
        configurator(cell)
        
        return cell
    }
    
    public func dequeueSupplementary<ReusableViewType: UICollectionReusableView>(kind: String,
                                                                                 forIdentifier identifier: String = className(ReusableViewType.self),
                                                                                 indexPath: IndexPath,
                                                                                 with configurator: ((_ reusableView: ReusableViewType) -> Void)) -> UICollectionReusableView {
        guard let reusableView = self.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: identifier,
                                                                       for: indexPath) as? ReusableViewType else {
                                                                        return UICollectionReusableView()
        }
        
        configurator(reusableView)
        
        return reusableView
    }
    
    func registerClass(for cellType: UICollectionViewCell.Type) {
        register(cellType, forCellWithReuseIdentifier: className(cellType.self))
    }
    
    func registerNib(for cellType: UICollectionViewCell.Type) {
        let nib = UINib(nibName: className(cellType), bundle: nil)
        register(nib, forCellWithReuseIdentifier: className(cellType.self))
    }
    
    func registerClass(viewClass: UICollectionReusableView.Type, headerFooterKind kind: String) {
        register(viewClass,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: className(viewClass.self))
    }
    
}
