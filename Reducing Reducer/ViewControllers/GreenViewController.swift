import UIKit

class GreenModel: Model { }
class GreenBindings: Bindings { }

class GreenViewController: BaseViewController {
    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.green
        title = "Green"
    }
}
