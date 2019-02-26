import UIKit

class Assembly {
    
    // MARK: - Properties
    
    static let shared = Assembly()
    
    lazy var templatesStorage = TemplatesStorage()
    
    lazy var storyStorage = StoryStorage()
    
    // MARK: - Construction
    
    private init() { }
    
    // MARK: - Functions
    
    func root() -> UIViewController {
        let controller = createStoryPickerController()
        let navController = UINavigationController(rootViewController: controller)
        return navController
    }
    
}
