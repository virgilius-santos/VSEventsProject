import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let dependencies: Dependencies = DependenciesContainer()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let nav = makeRootViewController()
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    func makeRootViewController() -> UIViewController {
        let controller = dependencies.showEventsFactory.make()
        let nav = UINavigationController(rootViewController: controller)
        return nav
    }
}
