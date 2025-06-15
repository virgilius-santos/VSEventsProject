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
        
        let appCoordinator = ShowEventsConfigurator(dependencies: dependencies)
        let viewController = appCoordinator.make()
        
        let nav = UINavigationController(rootViewController: viewController)
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
        return true
    }
}
