import UIKit

protocol View: class {
}

protocol Presenter: AnyPresenter {
    
    associatedtype T
    
    func contentView () -> T?
    
}

extension Presenter {
    
    func contentView () -> T? {
        return self.view as? T
    }
    
}

protocol AnyPresenter: class {
    var view: View? { get set }
    
    func onWillAppear(firstTime: Bool)
    
    func onDidAppear(firstTime: Bool)
}

extension AnyPresenter {
    
    func onWillAppear(firstTime: Bool) {}
    
    func onDidAppear(firstTime: Bool) {}
    
    func onWillDisappear() {}
    
}

class BaseViewController<T>: UIViewController, View {
    
    // MARK: - Properties
    
    private(set) var presenter: T!
    
    class var hasStoryboard: Bool { return true }
    
    private var isFirstTimeAppear = true
    
    var navigationBarStyle: UINavigationBar.AppStyle {
        return .default
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (presenter as? AnyPresenter)?.onWillAppear(firstTime: isFirstTimeAppear)
        if let navigationController = navigationController, navigationController.viewControllers.contains(self) {
            navigationController.navigationBar.applyAppStyle(self.navigationBarStyle)
            navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "navigationBarIcon"))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        (presenter as? AnyPresenter)?.onDidAppear(firstTime: isFirstTimeAppear)
        isFirstTimeAppear = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Consts.Colors.applicationColor
        navigationController?.navigationBar.tintColor = Consts.Colors.applicationTintColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (presenter as? AnyPresenter)?.onWillDisappear()
    }
    
    class func controller(presenter: T) -> BaseViewController {
        let vc = hasStoryboard ? instantiateFromStoryboard() : createController(aClass: self)
        
        vc.presenter = presenter
        (presenter as? AnyPresenter)?.view = vc
        return vc
    }
    
    private static func createController(aClass: UIViewController.Type) -> BaseViewController {
        return aClass.init(nibName: nil, bundle: nil) as! BaseViewController
    }
    
    deinit {
        print("deinit \(className(self.classForCoder))")
    }
}


extension UIViewController {
    
    // MARK: - Functions
    
    public class func instantiateFromStoryboard() -> Self {
        let storyboardName = className(self)
        let controller = UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController()
        return typeCast(controller, type: self)!
    }
}
