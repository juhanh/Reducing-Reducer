import Foundation
import UIKit

enum Command {
    case noop
    case showBlue(model: Model, bindings: Bindings)
    case showRed(model: Model, bindings: Bindings)
    case showGreen(model: Model, bindings: Bindings)
    case done(model: Model)
}

class Router {
    private let navigationController: UINavigationController
    private var blue: BlueViewController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func process(command: Command) {
        switch command {
        case .noop:
            return
        case let .showBlue(model, bindings):
            let model = BlueModel(text: model.text)
            let bindings = BlueBindings(go: bindings.go)
            blue = BlueViewController(model: model, bindings: bindings)
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
            let alert = UIAlertController(title: "Done!", message: model.text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController.popToRootViewController(animated: true)
            }))
            navigationController.present(alert, animated: true, completion: nil)
        }
    }
}
