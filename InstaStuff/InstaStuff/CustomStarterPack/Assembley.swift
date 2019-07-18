import UIKit

class Assembly {
    
    // MARK: - Properties
    
    static let shared = Assembly()
    
    let templatesStorage = TemplatesStorage()
    
    let imageHandler = ImageHandler()
    
    // MARK: - Construction
    
    private init() { }
    
    // MARK: - Functions
    
    func root() -> UIViewController {
        let controller = templatesStorage.usersTemplates.isEmpty ? createStoryPickerController() : createTemplatePickerController(params: TemplatePickerPresenter.Parameters(usersTemplate: true))
        let navController = UINavigationController(rootViewController: controller)
        return navController
    }
    
}
