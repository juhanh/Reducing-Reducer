import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var router: Router!
    var loader: Loader!
    var reducer: Flow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController(rootViewController: UIViewController())
        router = Router(navigationController: navigationController)
        loader = Loader()
        reducer = Flow(router: router, loader: loader)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        reducer.route(instruction: .start)

        return true
    }
}

