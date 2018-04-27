import UIKit

class BlueModel: Model { }
class BlueBindings: Bindings { }

class BlueViewController: BaseViewController {
    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.blue
        title = "Blue"
    }
}

