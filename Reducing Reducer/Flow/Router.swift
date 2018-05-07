import Foundation
import UIKit
import FlowKit

class RouterImpl: Router {
    private let navigationController: UINavigationController
    private var loader: LoaderViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func route(_ command: RoutingCommand) {
        switch command {
        case .showLoader:
            loader = LoaderViewController()
            loader?.modalTransitionStyle = .crossDissolve
            navigationController.present(loader!, animated: true, completion: nil)
        case let .showBlue(model, bindings):
            let model = BlueModel(text: model.text)
            let bindings = BlueBindings(go: bindings.go)
            let blue = BlueViewController(model: model, bindings: bindings)
            navigationController.pushViewController(blue, animated: true)
        case let .showRed(model, bindings):
            let model = RedModel(text: model.text)
            let bindings = RedBindings(go: bindings.go)
            let vc = RedViewController(model: model, bindings: bindings)
            navigationController.pushViewController(vc, animated: true)
        case let .showGreen(model, bindings):
            let model = GreenModel(text: model.text)
            let bindings = GreenBindings(go: bindings.go)
            let vc = GreenViewController(model: model, bindings: bindings)
            navigationController.pushViewController(vc, animated: true)
        case let .done(model):
            if let loader = loader {
                loader.dismiss(animated: true, completion: nil)
            }
            let alert = UIAlertController(title: "Done!", message: model.text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController.popToRootViewController(animated: true)
            }))
            navigationController.present(alert, animated: true, completion: nil)
        }
    }
}
