import UIKit
import FlowKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var flow: Flow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController = UINavigationController(rootViewController: UIViewController())
        let router = RouterImpl(navigationController: navigationController)
        let loader = LoaderImpl()
        let validator = ValidatorImpl()
        flow = Flow(dependencies: (
            router: router,
            loader: loader,
            validator: validator
        ))

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        flow.nextStep()

        return true
    }
}

