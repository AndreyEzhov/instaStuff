import UIKit
import Foundation

final class Router {

    // MARK: - Nested types

    typealias RootController = UINavigationController

    // MARK: - Properties

    var rootController: RootController?

    // MARK: - Function

    func navigateToRoot(animated: Bool = false) {
        rootController?.popToRootViewController(animated: animated)
    }

    func navigate(to viewController: UIViewController?,
                  reset: Bool = false,
                  animated: Bool = true) {
        guard let viewController = viewController,
            let rootController = rootController else {
            return
        }

        guard reset else {
            rootController.pushViewController(viewController, animated: animated)
            return
        }
        var controllers = [UIViewController]()
        if let firstViewController = rootController.viewControllers.first {
            controllers.append(firstViewController)
        }
        controllers.append(viewController)
        rootController.pushViewController(viewController, animated: animated)
    }
    
    func present(_ viewController: UIViewController,
                 animated: Bool,
                 completion: (() -> Void)?) {
        rootController?.present(viewController, animated: animated, completion: completion)
    }

}


extension Router {
    
    func updateHierarchy() {
        guard let rootController = rootController else { return }
        guard Assembly.shared.templatesStorage.usersTemplates.count > 0 else { return }
        var viewControllers = rootController.viewControllers
        guard (viewControllers.filter { $0 is TemplatePickerController }.first as? TemplatePickerController)?.presenter.usersTemplate != true else { return }
        guard let lastViewController = viewControllers.last else { return }
        viewControllers = [Assembly.shared.createTemplatePickerController(params: TemplatePickerPresenter.Parameters.init(usersTemplate: true)), lastViewController]
        rootController.setViewControllers(viewControllers, animated: false)
    }
    
}
