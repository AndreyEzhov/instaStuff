import UIKit

private var routerAssociationKey: UInt8 = 0

extension UINavigationController {
    
    var router: Router {
        guard let router = objc_getAssociatedObject(self, &routerAssociationKey) as? Router else {
            let router = Router()
            router.rootController = self
            objc_setAssociatedObject(self, &routerAssociationKey, router, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return router
        }
        return router
    }
    
}
