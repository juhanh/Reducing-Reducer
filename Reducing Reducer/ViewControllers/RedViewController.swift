import UIKit

class RedModel: Model { }
class RedBindings: Bindings { }

class RedViewController: BaseViewController {
    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.red
        title = "Red"
    }
}
